enum OpeningPhase {
  ready,
  shaking,
  charging,
  burst,
  walkout,
  reveal,
  revealed,
  summary;

  bool get isAnimating =>
      this == shaking || this == charging || this == burst || this == walkout || this == reveal;
}
