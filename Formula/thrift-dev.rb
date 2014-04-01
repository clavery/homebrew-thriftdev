require 'formula'

class ThriftDev < Formula
  homepage 'https://github.com/clavery/thrift'
  version '1.0.0dev-clavery'

  stable do
    url "https://github.com/clavery/thrift.git"
  end

  depends_on 'boost'
  depends_on 'libtool'
  depends_on 'autoconf'
  depends_on 'automake'

  def install
    system "./bootstrap.sh"

    exclusions = ["--without-ruby", "--without-tests", "--without-php_extension", "--without-haskell"]

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
    ENV.j1
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      This is not the stable version of Apache Thrift. For
      that use the thrift formula included with homebrew.

      To build angularjs bindings: thrift -gen js:ng test.thrift
    EOS
  end
end
