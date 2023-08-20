{ lib
, stdenv
, AppKit
, Security
, fetchFromGitLab
, rustPlatform
, protobuf
, capnproto
}:

rustPlatform.buildRustPackage rec {
  pname = "veilid";
  version = "0.1.9";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-mkb10JishprTyHV5lsFp/P57E2xTX+baHkJM4K2p4x4=";
  };

  cargoLock = {
     lockFile = ./Cargo.lock;
     outputHashes = {
       "bugsalot-0.2.2" = "sha256-9zLzK22dOB7w+ejk1SfkA98z4rEzrB6mAVUpPFuDUnY=";
     };
   };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit Security ];

  cargoBuildFlags = [
    "--workspace"
  ];

  doCheck = false;

  outputs = [ "out" "lib" "dev" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  meta = with lib; {
    description = "An open-source, peer-to-peer, mobile-first, networked application framework";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
