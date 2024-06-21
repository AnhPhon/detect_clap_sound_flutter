// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DetectConfig {
  /// [threshold]
  ///
  /// Minimum amplitude threshold to identify a sound as possible.
  int? threshold;

  /// [stableThreshold]
  ///
  /// Threshold to determine when the amplitude has returned to a stable level, helping to prevent repeated detection.
  int? stableThreshold;

  /// [amplitudeSpikeThreshold]
  ///
  /// Threshold to determine the sudden change in amplitude (difference between largest and smallest amplitude), which characterizes applause.
  int? amplitudeSpikeThreshold;

  /// [monitorInterval]
  ///
  /// Number of amplitude samples in the test window.
  int? monitorInterval;

  /// [windowSize]
  ///
  /// Interval between amplitude checks.
  int? windowSize;
  DetectConfig({
    this.threshold,
    this.stableThreshold,
    this.amplitudeSpikeThreshold,
    this.monitorInterval,
    this.windowSize,
  });

  DetectConfig copyWith({
    int? threshold,
    int? stableThreshold,
    int? amplitudeSpikeThreshold,
    int? monitorInterval,
    int? windowSize,
  }) {
    return DetectConfig(
      threshold: threshold ?? this.threshold,
      stableThreshold: stableThreshold ?? this.stableThreshold,
      amplitudeSpikeThreshold: amplitudeSpikeThreshold ?? this.amplitudeSpikeThreshold,
      monitorInterval: monitorInterval ?? this.monitorInterval,
      windowSize: windowSize ?? this.windowSize,
    );
  }

  Map<String, dynamic> createMapConfig() {
    return <String, dynamic>{
      if (threshold != null) 'threshold': threshold,
      if (stableThreshold != null) 'stableThreshold': stableThreshold,
      if (amplitudeSpikeThreshold != null) 'amplitudeSpikeThreshold': amplitudeSpikeThreshold,
      if (monitorInterval != null) 'monitorInterval': monitorInterval,
      if (windowSize != null) 'windowSize': windowSize,
    };
  }

  factory DetectConfig.fromMap(Map<String, dynamic> map) {
    return DetectConfig(
      threshold: map['threshold'] != null ? map['threshold'] as int : null,
      stableThreshold: map['stableThreshold'] != null ? map['stableThreshold'] as int : null,
      amplitudeSpikeThreshold: map['amplitudeSpikeThreshold'] != null ? map['amplitudeSpikeThreshold'] as int : null,
      monitorInterval: map['monitorInterval'] != null ? map['monitorInterval'] as int : null,
      windowSize: map['windowSize'] != null ? map['windowSize'] as int : null,
    );
  }

  String toJson() => json.encode(createMapConfig());

  factory DetectConfig.fromJson(String source) => DetectConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetectConfig(threshold: $threshold, stableThreshold: $stableThreshold, amplitudeSpikeThreshold: $amplitudeSpikeThreshold, monitorInterval: $monitorInterval, windowSize: $windowSize)';
  }

  @override
  bool operator ==(covariant DetectConfig other) {
    if (identical(this, other)) return true;

    return other.threshold == threshold &&
        other.stableThreshold == stableThreshold &&
        other.amplitudeSpikeThreshold == amplitudeSpikeThreshold &&
        other.monitorInterval == monitorInterval &&
        other.windowSize == windowSize;
  }

  @override
  int get hashCode {
    return threshold.hashCode ^
        stableThreshold.hashCode ^
        amplitudeSpikeThreshold.hashCode ^
        monitorInterval.hashCode ^
        windowSize.hashCode;
  }
}
