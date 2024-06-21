package techmind.studio.detect_clap_sound_flutter.config;

public class DetectConfig {

    private final int threshold;
    private final int stableThreshold;

    private final int amplitudeSpikeThreshold;

    private final int monitorInterval;

    private final int windowSize;

    public DetectConfig(int threshold, int stableThreshold, int amplitudeSpikeThreshold, int monitorInterval, int windowSize) {
        this.threshold = threshold;
        this.stableThreshold = stableThreshold;
        this.amplitudeSpikeThreshold = amplitudeSpikeThreshold;
        this.monitorInterval = monitorInterval;
        this.windowSize = windowSize;
    }


    /**
     * Default value
     */
    public DetectConfig() {
        this(30000, 3000, 28000, 50, 5);
    }

    public int getThreshold() {
        return threshold;
    }

    public int getStableThreshold() {
        return stableThreshold;
    }

    public int getAmplitudeSpikeThreshold() {
        return amplitudeSpikeThreshold;
    }

    public int getMonitorInterval() {
        return monitorInterval;
    }

    public int getWindowSize() {
        return windowSize;
    }
}
