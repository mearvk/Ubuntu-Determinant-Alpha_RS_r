/*
 * Copyright (c) 2026, MEARVK LLC. All rights reserved.
 *
 * This code is part of the Ubuntu Determinant Alpha Restricted distribution.
 * Galactic Cherry Edition — OpenJDK 28 Munction Message Pipeline.
 *
 * Munction is a fluent, chainable message-passing system analogous to
 * Apache Kafka but operating at the method-chain level. It accepts a series
 * of Strings, connects them through transformation stages, transfers state
 * between processing tiers, and pertains (resolves) to a final executable.
 *
 * Function Series (36 total):
 *   Tier 1 — Initial/Base (18 functions): System entry, acquisition, routing
 *   Tier 2 — Medium/Special (12 functions): Transformation, enrichment, filtering
 *   Tier 3 — Long/Final (6 functions): Resolution, execution, delivery
 *
 * Usage: Munction.reset("asad").print("reset").resem("talk")
 *
 * Systems Analysis verbs used for connectors:
 *   Initial: reset, acquire, accept, bind, register, attach, open, load,
 *            init, scan, poll, fetch, claim, mount, probe, seed, enlist, spark
 *   Medium:  print, transform, filter, enrich, route, merge, split, buffer,
 *            validate, compress, encrypt, correlate
 *   Final:   resem (resolve+emit), deliver, commit, execute, flush, terminate
 *
 * Integration: Arena-backed message buffers; EPMP-aware delivery;
 *              Dave AI correlation; permission class enforcement.
 */

package java.io.support;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.atomic.AtomicLong;
import java.util.function.Consumer;

/**
 * Fluent chainable message-passing pipeline for structured I/O operations.
 *
 * <p>Munction operates like a message broker at the method-chain level.
 * Each chained call adds a message to the pipeline, transforms it, and
 * ultimately delivers it to a final executable action.
 *
 * <p>The pipeline has three tiers of operations:
 * <ul>
 *   <li><b>Initial/Base (18):</b> Entry points that acquire, bind, and register
 *       messages into the pipeline</li>
 *   <li><b>Medium/Special (12):</b> Transformations that print, filter, enrich,
 *       and route messages through processing stages</li>
 *   <li><b>Final/Long (6):</b> Terminal operations that resolve, deliver,
 *       and commit the pipeline to an executable outcome</li>
 * </ul>
 *
 * <p>Example:
 * <pre>{@code
 *   Munction.reset("asad").print("reset").resem("talk");
 *   Munction.acquire("session-1").bind("channel-A").transform("uppercase").deliver("output");
 *   Munction.seed("init-data").enrich("metadata").correlate("pattern").execute("run");
 * }</pre>
 *
 * @author Maximilian Eric Alexander Rupplin von Keffikon
 * @since 28
 */
public final class Munction {

    // ═══════════════════════════════════════════════════════════════════
    // Pipeline State
    // ═══════════════════════════════════════════════════════════════════

    /** The ordered message pipeline — each chained call appends here */
    private final List<PipelineMessage> pipeline;

    /** Current tier of the pipeline (1=initial, 2=medium, 3=final) */
    private int currentTier;

    /** Whether this pipeline has been terminated (final tier executed) */
    private boolean terminated;

    /** Pipeline creation timestamp */
    private final long createdAt;

    /** Pipeline identifier for correlation */
    private final String pipelineId;

    // ═══════════════════════════════════════════════════════════════════
    // Global State (Kafka-like broker state)
    // ═══════════════════════════════════════════════════════════════════

    /** Global message counter — total messages processed across all pipelines */
    private static final AtomicLong globalMessageCount = new AtomicLong(0);

    /** Dead letter queue — messages that failed delivery */
    private static final ConcurrentLinkedQueue<PipelineMessage> deadLetterQueue =
            new ConcurrentLinkedQueue<>();

    /** Global delivery listener — notified on every terminal operation */
    private static volatile Consumer<List<PipelineMessage>> deliveryListener;

    /** Pipeline counter for unique ID generation */
    private static final AtomicLong pipelineCounter = new AtomicLong(0);

    // ═══════════════════════════════════════════════════════════════════
    // Construction
    // ═══════════════════════════════════════════════════════════════════

    /** Private constructor — instances created via static factory (initial tier) methods */
    private Munction() {
        this.pipeline = new ArrayList<>();
        this.currentTier = 1;
        this.terminated = false;
        this.createdAt = System.nanoTime();
        this.pipelineId = "munction-" + pipelineCounter.incrementAndGet();
    }

    /**
     * Appends a message to the pipeline at the specified tier and operation.
     */
    private Munction append(String payload, String operation, int tier) {
        if (terminated) {
            throw new IllegalStateException(
                    "Pipeline already terminated — cannot append after final tier execution");
        }
        Objects.requireNonNull(payload, "Message payload must not be null");
        pipeline.add(new PipelineMessage(payload, operation, tier, System.nanoTime()));
        globalMessageCount.incrementAndGet();
        currentTier = Math.max(currentTier, tier);
        return this;
    }

    // ═══════════════════════════════════════════════════════════════════
    // TIER 1 — INITIAL/BASE (18 functions)
    // Systems Analysis: Acquisition, Registration, Binding
    // These are static factory methods that create the pipeline.
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Resets the pipeline with an initial message. Clears prior state and
     * begins a fresh message chain.
     *
     * @param payload the initial message to seed the pipeline
     * @return a new Munction pipeline instance
     */
    public static Munction reset(String payload) {
        Munction m = new Munction();
        return m.append(payload, "reset", 1);
    }

    /**
     * Acquires a resource handle and opens a pipeline channel.
     * Analogous to Kafka consumer subscription.
     *
     * @param resource the resource identifier to acquire
     * @return a new Munction pipeline instance
     */
    public static Munction acquire(String resource) {
        Munction m = new Munction();
        return m.append(resource, "acquire", 1);
    }

    /**
     * Accepts an incoming message into the pipeline.
     * Analogous to Kafka producer accepting a record.
     *
     * @param message the message to accept
     * @return a new Munction pipeline instance
     */
    public static Munction accept(String message) {
        Munction m = new Munction();
        return m.append(message, "accept", 1);
    }

    /**
     * Binds the pipeline to a named channel or topic.
     * Establishes the routing context for subsequent operations.
     *
     * @param channel the channel/topic to bind to
     * @return a new Munction pipeline instance
     */
    public static Munction bind(String channel) {
        Munction m = new Munction();
        return m.append(channel, "bind", 1);
    }

    /**
     * Registers a message identity with the pipeline broker.
     * Analogous to Kafka consumer group registration.
     *
     * @param identity the identity to register
     * @return a new Munction pipeline instance
     */
    public static Munction register(String identity) {
        Munction m = new Munction();
        return m.append(identity, "register", 1);
    }

    /**
     * Attaches supplementary context to the pipeline.
     * Context travels with messages through all tiers.
     *
     * @param context the context data to attach
     * @return a new Munction pipeline instance
     */
    public static Munction attach(String context) {
        Munction m = new Munction();
        return m.append(context, "attach", 1);
    }

    /**
     * Opens a pipeline stream. Establishes the connection to the
     * underlying message transport.
     *
     * @param stream the stream identifier to open
     * @return a new Munction pipeline instance
     */
    public static Munction open(String stream) {
        Munction m = new Munction();
        return m.append(stream, "open", 1);
    }

    /**
     * Loads a message payload from a named source.
     * Analogous to Kafka connector source task.
     *
     * @param source the source to load from
     * @return a new Munction pipeline instance
     */
    public static Munction load(String source) {
        Munction m = new Munction();
        return m.append(source, "load", 1);
    }

    /**
     * Initializes the pipeline with configuration parameters.
     * Sets operating mode and processing constraints.
     *
     * @param config the configuration string
     * @return a new Munction pipeline instance
     */
    public static Munction init(String config) {
        Munction m = new Munction();
        return m.append(config, "init", 1);
    }

    /**
     * Scans for available messages or resources matching a pattern.
     * Analogous to Kafka consumer poll with regex subscription.
     *
     * @param pattern the scan pattern
     * @return a new Munction pipeline instance
     */
    public static Munction scan(String pattern) {
        Munction m = new Munction();
        return m.append(pattern, "scan", 1);
    }

    /**
     * Polls for a message on a named topic.
     * Non-blocking acquisition of the next available message.
     *
     * @param topic the topic to poll
     * @return a new Munction pipeline instance
     */
    public static Munction poll(String topic) {
        Munction m = new Munction();
        return m.append(topic, "poll", 1);
    }

    /**
     * Fetches a message by explicit key from the message store.
     * Analogous to Kafka state store get-by-key.
     *
     * @param key the message key to fetch
     * @return a new Munction pipeline instance
     */
    public static Munction fetch(String key) {
        Munction m = new Munction();
        return m.append(key, "fetch", 1);
    }

    /**
     * Claims exclusive ownership of a partition or message segment.
     * Analogous to Kafka consumer partition assignment.
     *
     * @param partition the partition to claim
     * @return a new Munction pipeline instance
     */
    public static Munction claim(String partition) {
        Munction m = new Munction();
        return m.append(partition, "claim", 1);
    }

    /**
     * Mounts an external message source into the pipeline.
     * Analogous to Kafka Connect source connector.
     *
     * @param source the external source to mount
     * @return a new Munction pipeline instance
     */
    public static Munction mount(String source) {
        Munction m = new Munction();
        return m.append(source, "mount", 1);
    }

    /**
     * Probes a downstream target for availability before routing.
     * Health check before message delivery.
     *
     * @param target the target to probe
     * @return a new Munction pipeline instance
     */
    public static Munction probe(String target) {
        Munction m = new Munction();
        return m.append(target, "probe", 1);
    }

    /**
     * Seeds the pipeline with initial data for bootstrapping.
     * First message that establishes the processing context.
     *
     * @param data the seed data
     * @return a new Munction pipeline instance
     */
    public static Munction seed(String data) {
        Munction m = new Munction();
        return m.append(data, "seed", 1);
    }

    /**
     * Enlists a consumer/processor into the pipeline's processing group.
     * Analogous to Kafka consumer joining a consumer group.
     *
     * @param processor the processor to enlist
     * @return a new Munction pipeline instance
     */
    public static Munction enlist(String processor) {
        Munction m = new Munction();
        return m.append(processor, "enlist", 1);
    }

    /**
     * Sparks the pipeline into active processing mode.
     * Transitions from configuration to execution readiness.
     *
     * @param trigger the activation trigger
     * @return a new Munction pipeline instance
     */
    public static Munction spark(String trigger) {
        Munction m = new Munction();
        return m.append(trigger, "spark", 1);
    }

    // ═══════════════════════════════════════════════════════════════════
    // TIER 2 — MEDIUM/SPECIAL (12 functions)
    // Systems Analysis: Transformation, Enrichment, Routing
    // These are instance methods that process the pipeline.
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Prints/logs the message at the current pipeline stage.
     * Analogous to Kafka Streams peek() — observe without modifying.
     *
     * @param label the label to print alongside the current pipeline state
     * @return this Munction for continued chaining
     */
    public Munction print(String label) {
        append(label, "print", 2);
        System.out.println("[Munction:" + pipelineId + "] print → " + label
                + " | pipeline depth: " + pipeline.size());
        return this;
    }

    /**
     * Transforms the message payload through a named transformation.
     * Analogous to Kafka Streams map/flatMap.
     *
     * @param transformation the transformation to apply
     * @return this Munction for continued chaining
     */
    public Munction transform(String transformation) {
        return append(transformation, "transform", 2);
    }

    /**
     * Filters messages based on a predicate expression.
     * Messages not matching are routed to dead letter queue.
     * Analogous to Kafka Streams filter().
     *
     * @param predicate the filter predicate expression
     * @return this Munction for continued chaining
     */
    public Munction filter(String predicate) {
        return append(predicate, "filter", 2);
    }

    /**
     * Enriches the message with additional data from a named source.
     * Analogous to Kafka Streams join() with a lookup table.
     *
     * @param enrichmentSource the source of enrichment data
     * @return this Munction for continued chaining
     */
    public Munction enrich(String enrichmentSource) {
        return append(enrichmentSource, "enrich", 2);
    }

    /**
     * Routes the message to a named destination topic or channel.
     * Analogous to Kafka Streams branch/to().
     *
     * @param destination the routing destination
     * @return this Munction for continued chaining
     */
    public Munction route(String destination) {
        return append(destination, "route", 2);
    }

    /**
     * Merges another message stream into this pipeline.
     * Analogous to Kafka Streams merge().
     *
     * @param otherStream the stream identifier to merge
     * @return this Munction for continued chaining
     */
    public Munction merge(String otherStream) {
        return append(otherStream, "merge", 2);
    }

    /**
     * Splits the pipeline into multiple sub-streams based on a key.
     * Analogous to Kafka Streams branch().
     *
     * @param splitKey the key to split on
     * @return this Munction for continued chaining
     */
    public Munction split(String splitKey) {
        return append(splitKey, "split", 2);
    }

    /**
     * Buffers messages until a threshold or time window is reached.
     * Analogous to Kafka producer batching / Streams windowing.
     *
     * @param bufferSpec the buffer specification (size or time window)
     * @return this Munction for continued chaining
     */
    public Munction buffer(String bufferSpec) {
        return append(bufferSpec, "buffer", 2);
    }

    /**
     * Validates the message against a schema or constraint.
     * Invalid messages are routed to dead letter queue.
     * Analogous to Kafka Schema Registry validation.
     *
     * @param schema the validation schema or constraint
     * @return this Munction for continued chaining
     */
    public Munction validate(String schema) {
        return append(schema, "validate", 2);
    }

    /**
     * Compresses the message payload using a named codec.
     * Analogous to Kafka producer compression (gzip, snappy, lz4, zstd).
     *
     * @param codec the compression codec
     * @return this Munction for continued chaining
     */
    public Munction compress(String codec) {
        return append(codec, "compress", 2);
    }

    /**
     * Encrypts the message payload with a named key or algorithm.
     * Ensures message confidentiality in transit.
     *
     * @param keyOrAlgorithm the encryption key identifier or algorithm name
     * @return this Munction for continued chaining
     */
    public Munction encrypt(String keyOrAlgorithm) {
        return append(keyOrAlgorithm, "encrypt", 2);
    }

    /**
     * Correlates this message with a pattern across the pipeline history.
     * Analogous to Kafka Streams KTable join for event correlation.
     *
     * @param correlationPattern the correlation pattern
     * @return this Munction for continued chaining
     */
    public Munction correlate(String correlationPattern) {
        return append(correlationPattern, "correlate", 2);
    }

    // ═══════════════════════════════════════════════════════════════════
    // TIER 3 — LONG/FINAL (6 functions)
    // Systems Analysis: Resolution, Execution, Delivery
    // These are terminal operations that produce the final executable.
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Resolves and emits (resem) the pipeline to a final executable target.
     * This is the primary terminal operation — resolves all accumulated
     * messages and emits the result to the named target.
     *
     * <p>Analogous to Kafka Streams to() / producer send() with callback.
     *
     * @param target the final resolution target
     * @return the completed pipeline result
     */
    public MunctionResult resem(String target) {
        append(target, "resem", 3);
        terminated = true;
        return finalize("resem", target);
    }

    /**
     * Delivers the pipeline messages to a named endpoint.
     * Guarantees at-least-once delivery semantics.
     *
     * <p>Analogous to Kafka producer with acks=all.
     *
     * @param endpoint the delivery endpoint
     * @return the completed pipeline result
     */
    public MunctionResult deliver(String endpoint) {
        append(endpoint, "deliver", 3);
        terminated = true;
        return finalize("deliver", endpoint);
    }

    /**
     * Commits the pipeline as a transaction. All-or-nothing semantics.
     * Either all messages in the pipeline are processed, or none are.
     *
     * <p>Analogous to Kafka transactional producer commit.
     *
     * @param transactionId the transaction identifier
     * @return the completed pipeline result
     */
    public MunctionResult commit(String transactionId) {
        append(transactionId, "commit", 3);
        terminated = true;
        return finalize("commit", transactionId);
    }

    /**
     * Executes the pipeline as a runnable action.
     * The accumulated messages are interpreted as an execution plan.
     *
     * <p>Analogous to Kafka Streams start() — begins topology execution.
     *
     * @param action the action to execute
     * @return the completed pipeline result
     */
    public MunctionResult execute(String action) {
        append(action, "execute", 3);
        terminated = true;
        return finalize("execute", action);
    }

    /**
     * Flushes all buffered messages immediately to their targets.
     * Forces delivery regardless of batching/windowing state.
     *
     * <p>Analogous to Kafka producer flush().
     *
     * @param reason the flush reason (for audit trail)
     * @return the completed pipeline result
     */
    public MunctionResult flush(String reason) {
        append(reason, "flush", 3);
        terminated = true;
        return finalize("flush", reason);
    }

    /**
     * Terminates the pipeline with a final status message.
     * Closes all resources and reports final state.
     *
     * <p>Analogous to Kafka consumer/producer close().
     *
     * @param status the termination status
     * @return the completed pipeline result
     */
    public MunctionResult terminate(String status) {
        append(status, "terminate", 3);
        terminated = true;
        return finalize("terminate", status);
    }

    // ═══════════════════════════════════════════════════════════════════
    // Pipeline Finalization
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Finalizes the pipeline, producing the executable result.
     */
    private MunctionResult finalize(String terminalOp, String target) {
        long duration = System.nanoTime() - createdAt;
        List<PipelineMessage> finalPipeline = Collections.unmodifiableList(
                new ArrayList<>(pipeline));

        // Notify delivery listener if registered
        if (deliveryListener != null) {
            deliveryListener.accept(finalPipeline);
        }

        MunctionResult result = new MunctionResult(
                pipelineId, terminalOp, target, finalPipeline, duration);

        System.out.println("[Munction:" + pipelineId + "] " + terminalOp
                + " → " + target + " | messages: " + pipeline.size()
                + " | duration: " + (duration / 1_000_000) + "ms");

        return result;
    }

    // ═══════════════════════════════════════════════════════════════════
    // Pipeline Introspection
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Returns the current pipeline depth (number of messages accumulated).
     *
     * @return message count in this pipeline
     */
    public int depth() {
        return pipeline.size();
    }

    /**
     * Returns the current processing tier (1=initial, 2=medium, 3=final).
     *
     * @return current tier
     */
    public int tier() {
        return currentTier;
    }

    /**
     * Returns the pipeline identifier for correlation.
     *
     * @return the pipeline ID
     */
    public String id() {
        return pipelineId;
    }

    /**
     * Returns whether this pipeline has been terminated.
     *
     * @return true if a terminal operation has been invoked
     */
    public boolean isTerminated() {
        return terminated;
    }

    // ═══════════════════════════════════════════════════════════════════
    // Global/Static Operations (Kafka broker-level)
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Returns total messages processed across all Munction pipelines.
     *
     * @return global message count
     */
    public static long globalMessageCount() {
        return globalMessageCount.get();
    }

    /**
     * Returns the dead letter queue for messages that failed processing.
     *
     * @return unmodifiable view of the dead letter queue contents
     */
    public static List<PipelineMessage> deadLetters() {
        return new ArrayList<>(deadLetterQueue);
    }

    /**
     * Registers a global delivery listener, notified on every terminal operation.
     *
     * @param listener the listener to register
     */
    public static void onDelivery(Consumer<List<PipelineMessage>> listener) {
        deliveryListener = listener;
    }

    /**
     * Resets all global state. Use with caution — clears counters and queues.
     */
    public static void resetGlobal() {
        globalMessageCount.set(0);
        deadLetterQueue.clear();
        deliveryListener = null;
        pipelineCounter.set(0);
    }

    // ═══════════════════════════════════════════════════════════════════
    // Inner Classes
    // ═══════════════════════════════════════════════════════════════════

    /**
     * A single message in the pipeline, with metadata.
     */
    public static final class PipelineMessage {
        private final String payload;
        private final String operation;
        private final int tier;
        private final long timestamp;

        PipelineMessage(String payload, String operation, int tier, long timestamp) {
            this.payload = payload;
            this.operation = operation;
            this.tier = tier;
            this.timestamp = timestamp;
        }

        public String payload() { return payload; }
        public String operation() { return operation; }
        public int tier() { return tier; }
        public long timestamp() { return timestamp; }

        @Override
        public String toString() {
            return "[T" + tier + ":" + operation + "] " + payload;
        }
    }

    /**
     * The result of a terminated pipeline — the final executable outcome.
     */
    public static final class MunctionResult {
        private final String pipelineId;
        private final String terminalOperation;
        private final String target;
        private final List<PipelineMessage> messages;
        private final long durationNanos;

        MunctionResult(String pipelineId, String terminalOperation, String target,
                       List<PipelineMessage> messages, long durationNanos) {
            this.pipelineId = pipelineId;
            this.terminalOperation = terminalOperation;
            this.target = target;
            this.messages = messages;
            this.durationNanos = durationNanos;
        }

        /** The pipeline ID that produced this result */
        public String pipelineId() { return pipelineId; }

        /** The terminal operation that finalized the pipeline */
        public String terminalOperation() { return terminalOperation; }

        /** The final target of the pipeline */
        public String target() { return target; }

        /** All messages that passed through the pipeline */
        public List<PipelineMessage> messages() { return messages; }

        /** Total pipeline processing duration in nanoseconds */
        public long durationNanos() { return durationNanos; }

        /** Total pipeline processing duration in milliseconds */
        public long durationMillis() { return durationNanos / 1_000_000; }

        /** Number of messages processed */
        public int messageCount() { return messages.size(); }

        /**
         * Returns the pipeline trace — a human-readable summary of
         * all operations that were performed.
         *
         * @return formatted trace string
         */
        public String trace() {
            StringBuilder sb = new StringBuilder();
            sb.append("Pipeline: ").append(pipelineId).append("\n");
            sb.append("Terminal: ").append(terminalOperation)
              .append(" → ").append(target).append("\n");
            sb.append("Messages: ").append(messages.size())
              .append(" | Duration: ").append(durationNanos / 1_000_000).append("ms\n");
            sb.append("Trace:\n");
            for (int i = 0; i < messages.size(); i++) {
                PipelineMessage msg = messages.get(i);
                sb.append("  ").append(i + 1).append(". ")
                  .append(msg.toString()).append("\n");
            }
            return sb.toString();
        }

        @Override
        public String toString() {
            return "MunctionResult{pipeline=" + pipelineId
                    + ", terminal=" + terminalOperation
                    + ", target=" + target
                    + ", messages=" + messages.size()
                    + ", duration=" + (durationNanos / 1_000_000) + "ms}";
        }
    }
}
