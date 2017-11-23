require 'formula'

class I386JosElfGcc < Formula
  homepage 'http://gcc.gnu.org'
  url "https://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.gz"
  
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "isl"
  depends_on 'i386-jos-elf-binutils'

  def install
    binutils = Formulary.factory 'i386-jos-elf-binutils'


    ENV['CC'] = '/usr/local/opt/gcc/bin/gcc-7'
    ENV['CXX'] = '/usr/local/opt/gcc/bin/g++-7'
    ENV['CPP'] = '/usr/local/opt/gcc/bin/cpp-7'
    ENV['LD'] = '/usr/local/opt/gcc/bin/gcc-7'
    ENV['PATH'] += ":#{binutils.prefix/"bin"}"

    mkdir 'build' do
      system '../configure', "--target=i386-jos-elf",
                             "--disable-werror",
                             "--disable-libssp",
                             "--disable-libmudflap", 
                             "--with-newlib",
                             "--prefix=#{prefix}",
                             "--enable-languages=c",
                             "--without-headers",
                             "--with-gmp=#{Formula["gmp"].opt_prefix}",
                             "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                             "--with-mpc=#{Formula["libmpc"].opt_prefix}"
      system 'make all-gcc'
      system 'make install-gcc'
      FileUtils.ln_sf binutils.prefix/"i386-jos-elf", prefix/"i386-jos-elf"
      system 'make all-target-libgcc'
      system 'make install-target-libgcc'
      FileUtils.rm_rf share/"man"/"man7"
    end
  end
end
