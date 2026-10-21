enum OpeningPhase {
  ready,
  shaking,
  burst,
  reveal,
  revealed,
  summary;

  bool get isAnimating => this == shaking || this == burst || this == reveal;
}
