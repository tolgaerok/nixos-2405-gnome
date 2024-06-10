{ ... }: {

  imports = [

    #---------------------------------------------------------------------
    # Import custom in-house environment packages::
    #---------------------------------------------------------------------

    # ./trimmgenerations.nix
    ./auto-home-manager.nix
    ./copy-back-up.nix
    ./create-smb-user.nix
    ./git_upload.nix
    ./make-executable.nix
    ./mounter.nix
    ./my-nix-commands.nix
    ./my-pkgs.nix
    ./nixos-archive.nix
    ./nixos-post-setup.nix
    ./nixos-tweak.nix
    ./rsync-back-up.nix
    ./rsync-home-to-server.nix
    ./unmounter.nix
    ./update.nix

  ];

}
