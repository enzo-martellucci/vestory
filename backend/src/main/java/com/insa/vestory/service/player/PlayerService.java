package com.insa.vestory.service.player;

import com.insa.vestory.constant.CardRarity;
import com.insa.vestory.constant.PackSource;
import com.insa.vestory.constant.PackType;
import com.insa.vestory.dto.player.OwnedCardDto;
import com.insa.vestory.dto.player.PackOpeningResultDto;
import com.insa.vestory.dto.player.PlayerProfileDto;
import com.insa.vestory.dto.player.UserPackDto;
import com.insa.vestory.entity.Card;
import com.insa.vestory.entity.PlayerProfile;
import com.insa.vestory.entity.User;
import com.insa.vestory.entity.UserCard;
import com.insa.vestory.entity.UserPack;
import com.insa.vestory.exception.ResourceNotFoundException;
import com.insa.vestory.mapper.CardMapper;
import com.insa.vestory.repository.CardRepository;
import com.insa.vestory.repository.PlayerProfileRepository;
import com.insa.vestory.repository.UserCardRepository;
import com.insa.vestory.repository.UserPackRepository;
import com.insa.vestory.repository.UserRepository;
import com.insa.vestory.service.pack.PackDraw;
import com.insa.vestory.service.pack.PackDrawer;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlayerService {

    private static final ZoneId GAME_ZONE = ZoneId.of("Europe/Paris");
    private static final int STARTING_GEMS = 200;
    private static final List<PackType> WELCOME_PACKS = List.of(PackType.STANDARD, PackType.STANDARD, PackType.PREMIUM);

    private final PlayerProfileRepository playerProfileRepository;
    private final UserPackRepository userPackRepository;
    private final UserCardRepository userCardRepository;
    private final CardRepository cardRepository;
    private final UserRepository userRepository;
    private final PackDrawer packDrawer;
    private final CardMapper cardMapper;

    @Transactional
    public PlayerProfileDto addGems(UUID userId, int amount) {
        PlayerProfile profile = getOrCreateProfile(userId);
        profile.setGems(profile.getGems() + amount);
        return getProfile(userId);
    }

    @Transactional
    public PlayerProfileDto getProfile(UUID userId) {
        PlayerProfile profile = getOrCreateProfile(userId);
        List<UserPackDto> unopenedPacks = userPackRepository.findAllByUserIdAndOpenedAtIsNullOrderByObtainedAtAsc(userId)
                .stream()
                .map(this::toDto)
                .toList();
        boolean dailyPackAvailable = isDailyPackAvailable(profile);

        return new PlayerProfileDto(
                profile.getGems(),
                unopenedPacks,
                dailyPackAvailable,
                dailyPackAvailable ? null : nextDailyPackAt()
        );
    }

    @Transactional(readOnly = true)
    public List<OwnedCardDto> getCollection(UUID userId) {
        return userCardRepository.findAllByUserIdOrderByCardCollectionNumberAsc(userId)
                .stream()
                .map(owned -> new OwnedCardDto(
                        cardMapper.toResponse(owned.getCard()),
                        owned.isFavorite(),
                        owned.getFirstObtainedAt(),
                        owned.getLastObtainedAt()
                ))
                .toList();
    }

    @Transactional
    public UserPackDto claimDailyPack(UUID userId) {
        PlayerProfile profile = getOrCreateProfile(userId);
        if (!isDailyPackAvailable(profile))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Daily pack already claimed today");

        profile.setLastDailyPackAt(Instant.now());
        return toDto(addPack(profile.getUser(), PackType.STANDARD, PackSource.DAILY));
    }

    @Transactional
    public UserPackDto buyPack(UUID userId, PackType type) {
        PlayerProfile profile = getOrCreateProfile(userId);
        if (profile.getGems() < type.getPrice())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Not enough gems");

        profile.setGems(profile.getGems() - type.getPrice());
        return toDto(addPack(profile.getUser(), type, PackSource.SHOP));
    }

    @Transactional
    public PackOpeningResultDto openPack(UUID userId, UUID packId) {
        PlayerProfile profile = getOrCreateProfile(userId);
        UserPack pack = userPackRepository.findByIdAndUserId(packId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Pack not found"));
        if (pack.getOpenedAt() != null)
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Pack already opened");

        PackDraw draw = packDrawer.draw(pack.getType(), pack.getSource(), enabledCardsByRarity());
        Card card = draw.card();
        Instant now = Instant.now();

        pack.setOpenedAt(now);
        pack.setCard(card);

        UserCard owned = userCardRepository.findByUserIdAndCardId(userId, card.getId()).orElse(null);
        boolean newCard = owned == null;
        int gemsEarned = newCard ? 0 : draw.rarity().getDuplicateGems();

        if (newCard) {
            owned = new UserCard();
            owned.setUser(profile.getUser());
            owned.setCard(card);
            owned.setQuantity(1);
            owned.setFirstObtainedAt(now);
        }
        owned.setLastObtainedAt(now);
        userCardRepository.save(owned);
        profile.setGems(profile.getGems() + gemsEarned);

        return new PackOpeningResultDto(
                pack.getId(),
                pack.getType(),
                cardMapper.toResponse(card),
                newCard,
                gemsEarned,
                profile.getGems()
        );
    }

    private PlayerProfile getOrCreateProfile(UUID userId) {
        return playerProfileRepository.findByUserId(userId).orElseGet(() -> createProfile(userId));
    }

    private PlayerProfile createProfile(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        PlayerProfile profile = new PlayerProfile();
        profile.setUser(user);
        profile.setGems(STARTING_GEMS);
        playerProfileRepository.save(profile);

        WELCOME_PACKS.forEach(type -> addPack(user, type, PackSource.WELCOME));
        return profile;
    }

    private UserPack addPack(User user, PackType type, PackSource source) {
        UserPack pack = new UserPack();
        pack.setUser(user);
        pack.setType(type);
        pack.setSource(source);
        pack.setObtainedAt(Instant.now());
        return userPackRepository.save(pack);
    }

    private Map<CardRarity, List<Card>> enabledCardsByRarity() {
        return cardRepository.findAll()
                .stream()
                .filter(Card::isEnabled)
                .collect(Collectors.groupingBy(Card::getRarity));
    }

    private boolean isDailyPackAvailable(PlayerProfile profile) {
        Instant lastDailyPackAt = profile.getLastDailyPackAt();
        return lastDailyPackAt == null
                || LocalDate.ofInstant(lastDailyPackAt, GAME_ZONE).isBefore(LocalDate.now(GAME_ZONE));
    }

    private Instant nextDailyPackAt() {
        return LocalDate.now(GAME_ZONE).plusDays(1).atStartOfDay(GAME_ZONE).toInstant();
    }

    private UserPackDto toDto(UserPack pack) {
        return new UserPackDto(pack.getId(), pack.getType(), pack.getSource(), pack.getObtainedAt());
    }
}