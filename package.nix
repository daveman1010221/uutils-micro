# uutils-micro/package.nix
#
# Minimal uutils-coreutils build — only the tools needed for a functional
# OCI container baseline. Compiled with --no-default-features and explicit
# feature flags so only the requested tools are included in the binary.
#
# Tools included:
# "ls" "cat" "echo" "printf" "env"
# "true" "false" "mkdir" "rm" "cp"
# "mv" "chmod" "chown" "mktemp" "chroot"
# "ln" "stat" "id" "whoami" "sleep"
# "touch" "dirname" "basename"
# "feat_acl"
#
# Closure size: ~52MB (vs ~1.54GB for the full package)

{ lib
, rustPlatform
, uutils-coreutils  # for src and cargoDeps
, acl
, python3Packages
}:

rustPlatform.buildRustPackage {
  pname = "uutils-micro";
  version = "0.8.0";

  src      = uutils-coreutils.src;
  cargoDeps = uutils-coreutils.cargoDeps;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "ls" "cat" "echo" "printf" "env"
    "true" "false" "mkdir" "rm" "cp"
    "mv" "chmod" "chown" "mktemp" "chroot"
    "ln" "stat" "id" "whoami" "sleep"
    "touch" "dirname" "basename"
    "feat_acl"
  ];

  buildInputs      = [ acl ];
  nativeBuildInputs = [ python3Packages.sphinx ];

  postPatch = ''
    rm -f .cargo/config.toml
  '';

  postInstall = ''
    for tool in ls cat echo printf env true false mkdir rm cp mv chmod chown mktemp \
                chroot ln stat id whoami sleep touch dirname basename; do
      ln -s $out/bin/coreutils $out/bin/$tool
    done
  '';

  doCheck = false;

  meta = {
    description = "Minimal uutils-coreutils with only essential container tools";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
  };
}
