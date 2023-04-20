{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  hostPlatform,
  openssl,
  pkg-config,
  libiconv,
  darwin,
  protobuf
}:
rustPlatform.buildRustPackage rec {
  pname = "nostr-rs-relay";
  version = "0.8.8";
  src = fetchFromGitHub {
    owner = "scsibug";
    repo = "nostr-rs-relay";
    rev = version;
    sha256 = "sha256-gWYBpT5GYS5W7hCLV79UGYO/1H9KXfKd3mo+Nz+y2lA=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  buildInputs =
    [
      openssl.dev
    ]
    ++ lib.optional stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
    ]
    ++ lib.optional stdenv.isLinux [];

  nativeBuildInputs = [
    pkg-config # for openssl
    protobuf
    rustPlatform.bindgenHook
  ];
  meta.description = "Nostr relay written in Rust";
}
