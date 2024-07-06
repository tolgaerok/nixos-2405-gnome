{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{

  imports = [ ./vmguest.nix ];

  #---------------------------------------------------------------------
  # Install necessary packages
  #---------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # virtualbox
    OVMFFull
    bridge-utils
    gnome.adwaita-icon-theme
    kvmtool
    libvirt
    qemu
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    swtpm
    virglrenderer
    virt-manager
    virt-viewer
    virtiofsd
    win-spice
    win-virtio
  ];

  #---------------------------------------------------------------------
  # Manage the virtualisation services : Libvirt stuff
  #---------------------------------------------------------------------
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

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
  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };
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
