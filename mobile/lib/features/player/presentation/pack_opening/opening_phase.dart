enum OpeningPhase {
  ready,
  shaking,
  charging,
  burst,
  reveal,
  revealed,
  summary;

  bool get isAnimating => this == shaking || this == charging || this == burst || this == reveal;
}
