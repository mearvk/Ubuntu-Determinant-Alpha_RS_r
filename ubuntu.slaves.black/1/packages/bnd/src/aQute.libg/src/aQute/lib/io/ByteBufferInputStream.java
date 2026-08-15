package aQute.lib.io;

import java.io.InputStream;
import java.nio.ByteBuffer;

public class ByteBufferInputStream extends InputStream {
	private final ByteBuffer bb;

	public ByteBufferInputStream(ByteBuffer buffer) {
		((java.nio.Buffer) buffer).mark();
		bb = buffer;
	}

	public ByteBufferInputStream(byte[] b, int off, int len) {
		this(ByteBuffer.wrap(b, off, len));
	}

	public ByteBufferInputStream(byte[] b) {
		this(b, 0, b.length);
	}

	@Override
	public int read() {
		if (!bb.hasRemaining()) {
			return -1;
		}
		return Byte.toUnsignedInt(bb.get());
	}

	@Override
	public int read(byte[] b, int off, int len) {
		int remaining = bb.remaining();
		if (remaining <= 0) {
			return -1;
		}
		int length = Math.min(len, remaining);
		bb.get(b, off, length);
		return length;
	}

	@Override
	public long skip(long n) {
		if (n <= 0L) {
			return 0L;
		}
		int skipped = Math.min((int) n, bb.remaining());
		((java.nio.Buffer) bb).position(bb.position() + skipped);
		return skipped;
	}

	@Override
	public int available() {
		return bb.remaining();
	}

	@Override
	public void close() {
		((java.nio.Buffer) bb).position(bb.limit());
	}

	@Override
	public void mark(int readlimit) {
		((java.nio.Buffer) bb).mark();
	}

	@Override
	public void reset() {
		((java.nio.Buffer) bb).reset();
	}

	@Override
	public boolean markSupported() {
		return true;
	}

	/**
	 * For use by {@link ByteBufferOutputStream#write(InputStream)}
	 */
	ByteBuffer buffer() {
		return bb;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append(getClass().getName());
		sb.append("[pos=");
		sb.append(bb.position());
		sb.append(" lim=");
		sb.append(bb.limit());
		sb.append(" cap=");
		sb.append(bb.capacity());
		sb.append("]");
		return sb.toString();
	}
}
