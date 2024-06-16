{ ... }:

{

  #---------------------------------------------------------------------
  # System settings
  #---------------------------------------------------------------------

  imports = [

    #./fonts
    ./audio
    ./bluetooth
    ./documentation
    ./env
    ./filesystem-support
    ./firewall
    ./multi-threading
    ./network
    ./system
    ./systemd
    ./unfree-insecure
    ./zram
  ];
}
