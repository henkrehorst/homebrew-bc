class AprUtilBc < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  revision 2

  bottle do
    root_url "https://dl.bintray.com/henkrehorst/homebrew-bc"
    sha256 "f58b787f99db4fed00b54027a0856c40d07693c02cd21b1d025a6430355ee0d6" => :mojave
    sha256 "79a4b42ec945afdad0bccf8929d128a45085e3382d5bd7688e897d9a98f08185" => :high_sierra
    sha256 "cf36aa4aeb7f61f7313c5ec7979cb61bc3fd8ebe3f3341912a85c2a99e5d0672" => :sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains apr"

  depends_on "apr"
  depends_on "henkrehorst/bc/openssl-bc"

  def install
    # Install in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}",
           "--with-apr=#{Formula["apr"].opt_prefix}",
           "--with-crypto",
           "--with-openssl=#{Formula["henkrehorst/bc/openssl-bc"].opt_prefix}"
    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]
    rm Dir[libexec/"lib/apr-util-1/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end