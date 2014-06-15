module CompilerHelpers
  VERSION_OUTPUTS = {
    :gcc => {
      "4.2.1-freebsd" => %Q{Using built-in specs.\nTarget: i386-undermydesk-freebsd\nConfigured with: FreeBSD/i386 system compiler\nThread model: posix\ngcc version 4.2.1 20070831 patched [FreeBSD]\n},
      "4.9.0" => %Q{Using built-in specs.\nCOLLECT_GCC=c++\nCOLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/lto-wrapper\nTarget: x86_64-unknown-linux-gnu\nConfigured with: /build/gcc-multilib/src/gcc-4.9-20140604/configure --prefix=/usr --libdir=/usr/lib --libexecdir=/usr/lib --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=https://bugs.archlinux.org/ --enable-languages=c,c++,ada,fortran,go,lto,objc,obj-c++ --enable-shared --enable-threads=posix --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp --enable-gnu-unique-object --enable-linker-build-id --enable-cloog-backend=isl --disable-cloog-version-check --enable-lto --enable-plugin --enable-install-libiberty --with-linker-hash-style=gnu --enable-multilib --disable-werror --enable-checking=release\nThread model: posix\ngcc version 4.9.0 20140604 (prerelease) (GCC)\n}
    },
    :clang => {
      "3.4.1" => %Q{clang version 3.4.1 (tags/RELEASE_34/dot1-final)\nTarget: x86_64-unknown-linux-gnu\nThread model: posix\nFound candidate GCC installation: /usr/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/bin/../lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\nSelected GCC installation: /usr/bin/../lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\n},
      "3.10.0" => %Q{clang version 3.10.0 (tags/RELEASE_310/dot0-final)\nTarget: x86_64-unknown-linux-gnu\n},
      "3.0.0" => %Q{clang version 3.0.0 (tags/RELEASE_30/dot0-final)\nTarget: x86_64-unknown-linux-gnu\n}
    }
  }

  def version_output_of(name, version)
    VERSION_OUTPUTS[name][version]
  end

  def success_status
    double :success? => true
  end

  def failure_status
    double :success? => false
  end

  def stub_shell_command(command, output, status)
    allow(Libv8::Compiler).to receive(:execute_command).with(command) do
      double :output => output, :status => status
    end
  end

  def stub_as_available(command, name, version)
    stub_shell_command "which #{command} 2>&1", '', success_status
    stub_shell_command "#{command} -v 2>&1", version_output_of(name, version), success_status
  end

  def stub_as_unavailable(command)
    stub_shell_command "which #{command} 2>&1", '', failure_status
    stub_shell_command(/^#{command}/, '', failure_status)
  end
end

RSpec.configure do |c|
  c.include CompilerHelpers
end
