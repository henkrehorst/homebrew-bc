class CurlOpensslBc < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.65.3.tar.bz2"
  sha256 "0a855e83be482d7bc9ea00e05bdb1551a44966076762f9650959179c89fce509"

  bottle do
    root_url "https://dl.bintray.com/henkrehorst/homebrew-bc"
    rebuild 1
    sha256 "c53d6ec19df5416a9b482ec45f397417137144b34dee6a09394ec74dff337fb7" => :mojave
    sha256 "c476debf62a3aed6b42733df8f3aabe5912c181c5875f16fc13f814cedcab2e5" => :high_sierra
    sha256 "6d1ff896b9e7da3e224a01cd3aaac2cb124c90467a65fb5e892abcc11124f507" => :sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "libidn"
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "henkrehorst/bc/openssl-bc"
  depends_on "rtmpdump"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-ares=#{Formula["c-ares"].opt_prefix}
      --with-ca-bundle=#{etc}/openssl/cert.pem
      --with-ca-path=#{etc}/openssl/certs
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --with-ssl=#{Formula["henkrehorst/bc/openssl-bc"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
