{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{
  #---------------------------------------------------------------------
  # Install necessary packages
  #---------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    OVMFFull
    gnome.adwaita-icon-theme
    kvmtool
    libvirt
    qemu
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    swtpm
    virt-manager
    virt-viewer
    # virtualbox
    win-spice
    win-virtio
  ];

  #---------------------------------------------------------------------
  # Manage the virtualisation services : Libvirt stuff
  #---------------------------------------------------------------------
  virtualisation = {
    libvirtd = {
      enable = false;
      onBoot = "ignore";

      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        package = pkgs.qemu_kvm;
        runAsRoot = false;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
  services.spice-vdagentd.enable = true;
  systemd.services.libvirtd.restartIfChanged = false;

  #---------------------------------------------------------------------
  # VM variant configuration - config MEM & Cores
  #---------------------------------------------------------------------
  virtualisation.vmVariant = {
    virtualisation = {
      cores = 4;
      memory = {
        startup = 4096; # 4GB startup memory
        minimum = 2048; # 2GB minimum memory
        maximum = 6384; # 6GB maximum memory
      };
    };

    docker = {
      enable = false;
      enableOnBoot = false;
      autoPrune.enable = true;
    };
  };
}
