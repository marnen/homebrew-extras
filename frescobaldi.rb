require "formula"

class Frescobaldi < Formula
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.19.0/frescobaldi-2.19.0.tar.gz"
  sha256 "b426bd53d54fdc4dfc16fcfbff957fdccfa319d6ac63614de81f6ada5044d3e6"

  option "without-launcher", "Don't build Mac .app launcher"
  option "without-lilypond", "Don't install Lilypond"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "portmidi" => :recommended
  depends_on "lilypond" => :recommended

  # python-poppler-qt4 dependencies
  depends_on "poppler" => "with-qt4"
  depends_on "pyqt"
  depends_on "pkg-config" => :build

  resource "python-poppler-qt4" do
    url "https://github.com/wbsoft/python-poppler-qt4/archive/v0.18.1.tar.gz"
    sha256 "9d6dfe7530c26d6062fb370fbb068bb554d9c3ed0b82dc640c362fdc62ca0947"
  end

  def install
    resource("python-poppler-qt4").stage do
      system "python", "setup.py", "build"
      system "python", "setup.py", "install"
    end
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    if build.with? "launcher"
      system "python", "macosx/mac-app.py", "--force", "--version",  version, "--script", bin/"frescobaldi"
      prefix.install "dist/Frescobaldi.app"
    end
  end
end
