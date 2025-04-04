# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./chur-hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Disable IOMMU for Snabb Switch.
  # chur has a Sandy Bridge CPU and these are known to have
  # performance problems in their IOMMU.
  boot.extraKernelParams = [ "intel_iommu=off" "hugepages=4096" "panic=60"];

  # Enable kernel MSR module
  nixpkgs.config = {
    packageOverrides = pkgs: {
      stdenv = pkgs.stdenv // {
        kernelExtraConfig = "X86_MSR m" ;
      };
    };
  };

  networking.hostName = "chur"; # Define your hostname.
  networking.hostId = "1ab1e8b1";
  # networking.wireless.enable = true;  # Enables wireless.

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "devicemapper";

  security.sudo.wheelNeedsPassword = false;

  nix.nrBuildUsers = 32;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    gcc git gnumake wget
    emacs vim
    docker
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  users.extraUsers.luke = {
    isNormalUser = true;
    uid = 1000;
    description = "Luke Gorrie";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcsvXQs8U1TYZyGYLusQpOtBvmyvsa0wqxIUXrnmqIHY9HX5D0SYYra7Vy0b8SjNsvV9ywZZRi4b1BnKNG6Gxe+JMC9+mokBCYTo68gclfYAWS+x0DzO7KEPh9PeFUrYuUYekRaK42j923LBBMIQOwtPDhFzgRoYXZEaBCtUyCHrUi98b0CWL1uu0C7QfAoXLXY5l2pndT1tyxZnYg0rlohuhCDsniZZ+Em2mV0235lJ8l7UbvV3fASoAW4qEs3jkvBXwpDGKBJEoev6trM12FC4ZSiKcH7LBLxz2G5KCfRht46cXtp379xRBfAVI5z2WCegIGtRhNto591BRIBCmj" ];
  };
    
  users.extraUsers.rahulmr = {
    isNormalUser = true;
    uid = 1001;
    description = "Rahul Mohan Rekha";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN+Jf2p88GlKPHHxIM0laFQxYY1si+PAqAYhIu0/t/vShla8YAM+iHrwIwV/4G56aFxJHsJ15ysQWc5JSQkDCvzYiE223MAzub+vnDSpCm7+A8R65+8kqSq3RLzu1QAFXQ/Aaw2I0CMg4szwdFU+bxiApeH8rkuWBHuab0oPaZINPA0T1OfT6nr8HU69ZuZ0uYRIr38SR6jd/dJxHUEuSx/0HpSWypWA33wfuTMrOmcqn/jIm1r2DLo9HnDLu702oNx81f/qRaSwod91rJYUnIk3ogKaAJCEbIFyUqj1x9KgzUU3Nao74uAr9dVBGd/haqHXsmelLwwK57zi0HXt8L" ];
  };
    
  users.extraUsers.pkaz = {
    isNormalUser = true;
    uid = 1002;
    description = "Pete Kazmier";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAqMh9z3EYfvGxSaCN/C/WH7VnvnJvfEoIy25Ee/rKBgifn0pWhK502v4+GSFzmSMrrl5SfklrzIpgXf9LCFHNx2K3uiAbNrUqfpzqMBHHB4r5345IUFLCe7dp7Tdd92dIMrHVCgp6CyGkVt2XgCzO4mRbXFWg9MxbY9s7xZb+3cE = " ];
  };
    
  users.extraUsers.justincormack = {
    isNormalUser = true;
    uid = 1003;
    description = "Justin Cormack";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAP2Fdv3WpJ6sVellvOx1Z/g92KiNVdTmk3zZhFwDHScCMxt2QALUM/fkIv7mJGk2IKyP66DwImIZmLy000PBVFna9ljhOutesJxRCh8jNUAc0QbY7SR+EkcGVwgLqW7hGUIFU3T320AtUmCmkhoPct3gwNVi/f7yICzZMhnsHktAAAAFQC4DjtemVp453YI2icQbuIxjqVI9QAAAIEAyBKs8XnweQLU6r5GOcnWnNjFkmLDHNdIoeXAFU4zpCrP71wopBn7jqOGv62HQCwNhIMf3fw0iT1WhOdoqqjhnxkLS97O5X4y01ZWviMyUEJ/v1lcxF7UKtC40ZGj0V1v1lWc/sFuKJ7gCul80zqDQSwtFr1XAxk66sezvUZRMEAAACF7cHXazx+7fXUxyLgy4aKL7R6+AP2zZJhjBde/4S0uOwLxurL9ap1TqAR1fdW8avchQ86zy7IuPMsrUV0M8KvEWIvxVlwpS/OQ88BTDb16AZpZXfWSi7t0B6cMIqEM/BaB9y+/0CrahvpOeVqgLCR4woKJAW9A3I7LUL6lq5bE = " ];
  };
    
  users.extraUsers.wg = {
    isNormalUser = true;
    uid = 1004;
    description = "Will Glozer";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDarVruCoGwscDcL9IgAWneBcSfXgGq5F+mJcAW7zBmauOA0sSLUAs0yFazZ+kXpQ9B6lwLINcg/tUoeeYTqg1kX8U/+yjRa7uynISHh8yBSRn3oktvcjPCjfszO3iyXQ7jPe5EwX3r03k3POQExuTGV8wNro7f34jaQA0R8nhH7UUB8yiT6cq0AC/1/lTUgOoG2SWwuwLFKBE/RSIqB9zyR+4OwAlwbxE0SXmOF60s57Bv0E3rf9SkCJmiU0HNSaoR4DT3Tug/wWwf1MQOpZCgrNpBpgsW05eo7dEjwMpLRzRwXbvul6HnihY9NJslASskfI/G9WswSe2+67rBZF29" ];
  };
    
  users.extraUsers.javier = {
    isNormalUser = true;
    uid = 1005;
    description = "Javier Guerra Giraldez";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxOGl1egCc4VvuMyoNpgj2v723aVD2kIW8XplbDQdMUscaJxNN7jNL2Vxe75iWMxnzTw/vQ70H++RCizSZplK95q0A3i7CC33TXMwfvI1eM4x0V/WxyXDrFOVNlFghb38ROF95c+4q9MLCXtxlqwcQ1Xq2+twQ/lrYoPNXjgOfFJogu7fETOURiqfgw2ChohGcf1w6NZb6OFd/XBavqiNso8ZdeKQnNBYOHrp4cpoGfZ0iUf1cc0jc/wUHEZGZZWCTK660uPXjvkxEdewaaZCHhhrQPqUUErLWSZizo6Y1YTBVAMjKKI6gdcpJbKgp1cxZM1YWDKmUI/z6kQghmVe/" ];
  };
    
  users.extraUsers.jeff = {
    isNormalUser = true;
    uid = 1006;
    description = "Jeff Loughridge";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdWxznJSVvw/cxwGvJ4j7LgTHQ1PQtc6vB9nlHei2B18MbLNT0iSgzu7WC+2+dFvwSoUfb0mT0GiV/wGSAl6d51FWfFbb/mXTOcpeq7c0UaBXxjcX5K/DbjuNHQH0JP3md+ZqJnckM21nJLGAkVJGIDtdv3RXqFpBr4FZL44MXiO1QQdxWqvZstl6cB5AQl0z1SNpVWL8SLCxseAn5UinIVKTTULYgiPgQfML68D5gLFT7ZFzpEP5rsF7mLkYI6/sYxOl6DItdEnwh5C+P/pWS6IA8vAWYpYbFiBqw22tc281Z1TS0QlvReUuY/BWK91D+gZt7GlBYNvSzeG4YsPAR" ];
  };
    
  users.extraUsers.gall = {
    isNormalUser = true;
    uid = 1007;
    description = "Alexander Gall";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAOuCMNqMbu5cCTXbHFI40mBDsao9wkGHYVUV/bmCs1w4vap+pj2kY8TXZUi/O45rN90ZhWTa9HL+ptNOi5n02zN6SH3UyIRO5uQ58dJN0fPC9dn9uRe/wEdVwaQZOXnmuryDOPq0198hmimMWhUhPDL0hyCv31VB2D+rnVPHUTIHAAAAFQCC6BVJTwJV6k+icBy5PPqtvD2iQQAAAIA84QAgpuDRp6RbC47qOFQqGugLISgovvraJbKQB8z/bVlzsWzuRCl2YfG2MOnh26JusRLm9shDUHSzxGkXsWSPHWMhibC0NoeKG4sWoy/rPGsZLFltBEZiLBCnLXR/NKnUHNF/gg9Wx+VPWNz+KZMik00CrZmAVYrV3gcKtUFG+wAAAIEArYXur6MRnIUZ1vk9BOHcD3PN8JS4Ks592n7xUNbG837WFKMWm3MwsIsCkO7B2m1Qkkuvse9449UNMogMM3yaJM8KoRtX+AlFiG8DkzW0QjQ2DmGS1UPminZq2GzQRkFMANsOk0ketq9nokoRLjT3AVfI/kBIIh51sY1UKU5JEe8= gall@enigma" ];
  };
    
  users.extraUsers.kkielhofner = {
    isNormalUser = true;
    uid = 1008;
    description = "Kristian Kielhofner";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAAEBALNdKl9b+PBQIEEUMj8TTChidWKietnkPZGw85UffTgILuSGNl4lKCRW5t/I2Ubeef7IbSqVFaqy0+P7rQ+IGqYqgIyaFIa74Aohb8cwECDXUl++nPU2o8oXz+3QIOl/RvQ/8Su7R7TGo7FrLHTumAItFn/zNmHge9zP50AoUDBZEyDYi+QJrt2zKmBFpIEiUjC1ymu22Nodi4mC/C6jS6ILJQT4/sBik2Zn43o5PGnV9OctUCEEiZQ1P5BK/ED7GC6XOV6BSCcvNfhdvQuEsjQDtcrGpOgGHbBxSGJ4zNCYmhHV71FF4tJBw6liBMZEV1g3HGU3w12jcMaqP7eoKD8AAAAVAKqcre4yE0Un18g0u0MVrQp0z6WDAAABAQCDULWYKqP6Alhw7xiIe3wtApDkuWLUcwOFOkj3iL2e5K9QiK6nBQCHB/icOaK4zEmZHLVZUFRkiXMbvTV+Nj6UTB9Qfo44z41K5L4XEiC685CB5IYyujNIkc6DyEGztVEPOJIjJFrsiA26hk+CM4s+N/ueUIGm6sZruTbvaUSWrQufJAe2DI00Xi3ocmPzh7vnaaTcwh3YWguodDy8r4nWaeoPPjWctyxYqrcf+Xj5n0hz+UG4YQeftAztkMx8b/7VGUihMLNDF6p4qVuXolMaieGKfvqY31tk/Bz5biQjyBXx73R4TdwiD9MydVlstXPKTnSBy7vR/0Yq0UMkJEEBAAABABEY0IbGlnUhtbRgZmu9cVnWSugn73aVxSB4uPokx/zvXq2Ydl0sphZGw1wwyEf5fd5uXZ+G5N6TCNi/+yBltiwYI9/UCAzYE3ALI4oHeCQezYdh01Ciwd4YcVVp+5dDNW2n7Zrr8FPqqAsuvBYZIgDj6YR93opx61bFMGuCw1hKSr33JBoZtEBR3wsIF9VTVb47va6bRKCzp+8WzDYBRpMIWhkGmO6bmHvd5gAexeL00RGIp1CJlcrL2+sARUfV+qqYMDYO5x7PgEbCVylPzZP5dDtPWJHAovfXedr66v8K1SfOyp19o9clcFAQk96bWL60vu1gvWRguDmCMfc02jc= Kristian Kielhofner - KrisCompanies, LLC" ];
  };
    
  users.extraUsers.jfenton = {
    isNormalUser = true;
    uid = 1009;
    description = "Jay Fenton";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvqo1Xk7r6rb/B2ghTvKTcJHRcnsy7+mYosIjQ+mwOFqdaM+CysAxyIAKlOHtliR5fnAsrttYATDcrzauhzXW2tinBohhiUjLW1QdvO2mt2IqHrz/wYTzaJ0YqKJ13ngqj8OTbkV0Q4etCQqkF58BuVant8NC0owYuVSnRwJ4PWHTxTVXDfJaVO5BUQaImpfF/tLQcGN6pKyog57Hh8RYVUae9pcxKkhheoIoQi7dTyh11lwWrwfsqIETy3j0Mew3v27/xYREzpVSawZVDtuF9/mDPc+anY32ODZ0WlgFeWuGMxopazsTmOlKmbDv5g0R7E3ZWz8xdiMJJg5yyR+uiQ== jfenton@lap0.na.nu" ];
  };
    
  users.extraUsers.andychong = {
    isNormalUser = true;
    uid = 1010;
    description = "Andy Chong";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEA3/KAsqRGAGH3QC5YdG/oKqDO1siBxNER41pAswY10XHq60mJ8EpBjqIX8tLHGUsvLzz4DFEC2khI75gk6DqnEgQQq7IHwMeBQ7799qX69szdmn617Ot7nqlocWHkeUpFV3GXO/QLIftwv3sfg4/f8osI6Fs40FgvybChn6YGdZE = " ];
  };
    
  users.extraUsers.yoko = {
    isNormalUser = true;
    uid = 1011;
    description = "yoko@nii.ac.jp";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg7IXEVsmPwX5Oc41d5F8HrpYj8LCWJnnLo4jfb9dmuwUgjUXR/MHeph+/zHsXVplBlLB0swQtxdkAgLMNv4hHHNsAK+ikvVFQrFm6zBTuZY8xVar72rHNkUi3md8O09rBhRQXm5r27OEkWQlTn0TtZ91ZkWkgv/zuAY5iV//SuPjBiPFX0m3JlDUG1J1I+1Y/N+/o/TUS2lyQcCeA/0vkVjUr8+NZs3zJor6TCQuWN06UhBbpuMs85HqD3hPatZhsDvC/1VhX2ocbBq5+T7JF9iflJCueZp0E1tv+p6v0j0KLTUcQnwyRPMKC62oVb+PEvNaA9iYEMNwNW/SwHLXp jxta@cn02041403" ];
  };
    
  users.extraUsers.eugeneia = {
    isNormalUser = true;
    uid = 1012;
    description = "Max Rottenkolber";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQC/zwFEk3x5wI0hZAr91DIWRL0YlWwBgJ0XoFJE0aRnblQ842Cg7cKAgNVnRhgBd8Wz1xGxAOOE0uTGuUs+2wP9/XAL82pjOg9gPqL2B55NnihK4MDykAzGrTZQlUoaVH4ukmiSyaw3W83BnLjg/lQue/71DYhmmWYYj5W1RNLsQMHW/7Ddp/3vJv+Ltffct01eQvzG809/PLz7hCTNFauWTLEWB6hPXBpVR8gMRlOaDzEoGo0/lTKPZNwbPTIGrdRWWhOXfF+JBEl20lS8MVFcC66aHQoIPEg4ADJtyNJMYB1lFH4Pm+fgeaU+j6d621ju45EWOgLwSw49EjaITKnnrrOv/B+lCeIbFEi9J+Whr77KU1PsVqSkfbqStoWOWIlQJmyhuq3FDUZaYj7LSDjbSxJhmqd+SODLz1wJ1/dP2mCdErI4QyXfbV4f6AIdDYXQ4s7R3XJ2yn4rdXFDnYhJgbQ/IZIqMpg1NGjeNBJfahzzMSZTItCMb1kyY6dCMruQiEr1RRlQkIQurYVkq5NrBg2DHbmA5ZmZvd41h58o34tEsCe9cTaUdmYoiA1PHCtsl4LaEOvsjzqr7mTdfT1Le0v1//4k65XpRf9peNxtyTs1c899i2iq7WLTdrssuPo/AOrB3dm3hcUIwqO/toHAN/vKHht4242UypDLJXEcXLQmafCEiI1xW9Q9ZbDTYCksJ20WzVW5LCe0CyXMyB/0AuRvnaTDbUANH+J7JKh5zuhtjBcmYzTFt8QkJjj4yRTTMlSxC6T2JvJxaSf25kJ7eHzt+zPiQ1QN7jECPpi5jpxIcy4GQk7AfbDW5DMI1SM250Kao6BLBZ5cI5fFIufMMmLdHLaWgC9tF/A5p0c+etvXMQFkdZ05FE+aHqVrabArHIAIiNfzKKDaGyTPh9X4s0f4lWeYhu0vlEU69JW05tYm+HP+1j1lARKwKlbQ509sxP4126irMtV6ksO/3IrryKlTFMaKax10fJwvfRwQkNjuYvd5I2CWN7oGinjggAO757nI6gK+D0WfilAPguS21CFq+9hyA2THs5KXfXap2dsqFmJCiu78KslcDmCTG0PwenBii2SrYuzddJnGjTk0HMZc26nj02XgoQhlaVOvjQYzx+8PPg5V6qwjcOhKRp4/7wwFWqt1twj4O3SBd1PhTFrY+SFfSaGNTqaeWiaLkQ1nN5UsNNTonLPiCj8gwsJKg5MwwOlFcPxyIjdXayQ3dRBiyyW8sRPHx/vyK0Xt3uH3dTBMt+oxTOlxj6s0jWIJ6zbsBiyATsvf8HwNeX1KU2NSrgUj+oarmuYKa+PX2+N0EKF9u0v9iN99LH/1/v4ilpSwwugZnWXwXdJeXjqn eugeneia" ];
  };
    
  users.extraUsers.byterians = {
    isNormalUser = true;
    uid = 1013;
    description = "byterians";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDzCW2/OrSsiJQroxILKzY2WwRayNo+PAOBo9WTStSS1O6rcAzSTVfKt5EyJTjOTpT9lzvNk7yxrRE1zGZSIoDsFGYNgsRkfSCkIkO59SyHveEl+OchaDVqwn+Jl7XR5g1hDmhilwdzXpWfuvJ7XpZMgpZi6/bndnXbiiHrNnmRJd6Hnd4eQbsQSdEKyeWdZgxVjgJd7dGIpylgZtlL4vQM5Hhq48wdB4P3a71lRTHdyTdbolaCM7yCHwKcd3N6QaOmJrmsf/iAPvnXWVkfrlJM660hypN3SfwLsZPRDvYGXY7Kg1ulDBO1azQrJFmsdEq/JvHeJQZlSCXVSsMkHPlR saish@saish-Lenovo-IdeaPad-Z510" ];
  };
    
  users.extraUsers.xianghuir = {
    isNormalUser = true;
    uid = 1014;
    description = "Hui Xiang";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPnTaAORQB9ZeJiRygykP609cpLYXLGBbURe/Y6m+lkMDaIUOobYqek08dzRhCVwRrTOgWQYL9HwTN5fRCpvV8dYcXjnvmWI+17TOmTdjxmpRKypLAnpuIDmKkYWIEsCHQxo10cNlUbXhMIgJSGHGnP2kgy1UQ6afI2Gu8onfBAP0UHOPBY3exuM1BBcVY4Zjg3xP1bkQyI6+2HiGpXBCkR0mjVJuqrSOUv0UyqXwcLWQ1N15sd0QwROW3WvuGAFl5XYbwJaozz7TeQIavdgiUC7e4Gn0Qr8iugqgzuylKpK/KnvWWWsAk34O/Sq4KiUmv/yEgN/0X2Libd0sh3qvD xianghuir@gmail.com" ];
  };
    
  users.extraUsers.anshulmakkar = {
    isNormalUser = true;
    uid = 1015;
    description = "Anshul Makkar";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJygmBLFdIaY0SO7BbgBaezGbhQUKyUZ8RA0V7L47SeFu5evRfBb0Mdp3dGHhvDIxQfwFNDW6HQes1lW8Rf8RJBVXoySy5SBNddVgZNL6v/zZ7UY/m7TEInsY6PvqMz6KtnptA6xDbcQhDQPQOxv9oQZtgHYnOnnM7vY0XqfqjH9wGrfSftLPMHH/ijSewa1xhgp0TpS+7WLkDn0Cen9kxEyPoTRGUKDvRDnTZL6CAG5rGx9hzRxUH8nYsvrjciPrWtDsAu0kdMjHujD4Eb1qUgveh0Q7ZTMd3RXwYAVx3A4wRvccm+vaQYorf3NzB8gwp2Sz3+EjfVUgaDMzeZgwh anshulmakkar@gmail.com" ];
  };
    
  users.extraUsers.jamescun = {
    isNormalUser = true;
    uid = 1016;
    description = "James Cunningham";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBE59E5AXlUqpSSHCS6TvUxPwuLadIBqrT42s3yt7PMAP5xPC2ZENXt7k4PM4gFQMLuF5kpiTT9claeSu+r+X0ydsrEpnesgqjoKOfHTp9WPIZuZdBXH97fxO8BF31g76Bp8HmZ53xWpZAfO+iwzvr/0yPKm8Ba3rs6OMaemd+zDPHrAeI1wn0LWYwAlxTSKl9IHRDZjv5t/3fj6h5STz+D/j9Uj5fBdFqnPdQoPp1CTfp6OZR9h3JTysH2OpYbYhlSje0YCZuavPfpkXGXVeqzqEoiJnbd8M/IxiP2hQuUQwOLW1bOnSKHXOldKITi/Ax1pH88onZYLEzIdWgmsi9 snabb@jamescun.com" ];
  };
    
  users.extraUsers.koriczis = {
    isNormalUser = true;
    uid = 1017;
    description = "Tomas Korak";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB09q11KKRPQDrioesdIQRst7FLZMmSNUBvS7GCvUapAZ253QMO1+akEletdrFMtnZ53FG+r756hWUG5157Xq3p2RJkM9/vI9MIovTM0SnzP7mHwvrzRThomZ600l4on8Xi/pET47dkV9MxADR/RAKo5cmc3N1/jYhB8v5U18AfDGYKBpqvp2yyIOX0Ems8ULFzNAnUXWqFWS2sQxZmVp69Y18gxYZ9iqtxEK8vGjLKkJpPnkyceqmVfydgoTCAHdpgmALgjtSmUsrvpCugpJ/1G/gAR6JOoxM75yf3/1lji/cWlUyeQZfa9E+yj6R8Cd3pd9BjwC14l7qjhP+JBkh korczis@gmail.com" ];
  };
    
  users.extraUsers.gnusshall = {
    isNormalUser = true;
    uid = 1018;
    description = "Gernot Nusshall";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMWVJSlUBy6n1Cs6hghcelT57yNlSFyLX1uoiuab0USeFhIH8EmcYkwD7AfouVZMVQkEw7AFZ8tZYVMCSou59ZkkHDzIR+pN8/SkizyqOxRwHDxvpezpKSIXvF/t8NsAtV4f8Q78ZSvUFTio0qR2gQWgbaFCh3q10k9oEgtLNNBRnHKKGJRc+cZ85eaHZ4RCGgYPVpyAaq2/wV+ILztSlI96OqDodxH4ZCQOAwodeYRosiuuOL5YR7CW3uI1taiT1DI1RMo18JBXFePkNfEdRNiOiPSVsM2AyeRMyLcXMoOC74A7zKM2ziKfrAERpA1rCwPbzsQ4mqRI/UHpYGqeIl gnusshall" ];
  };
    
  users.extraUsers.ba1020 = {
    isNormalUser = true;
    uid = 1019;
    description = "ba1020";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA/LBekkfhV02p4Jq+JtR74P0YuViJ7Bg7DcE9UPd0YlZEsMw7bfv4VYBHNHzCpr4krcICLfgRKkraQHJaAtcgOsSe9RDCtpDIVq7b0e68ASjOQlgKpF/X0uGdF42Q4kMg5PKr2PJZEfWc/EU9XuqEPzW6rvG9Wui4Eo27MjR3Ke4cmW8ZSvBfr2d/Ov59rMYnzW5jOtQI/hrcVboVPZLOUxm8FjzZ+uRKX/xbWIOYwU3lAzd6/5tIwu1acV3ik433mN5hUrug2OFXXmTuwr1JpuJ/hTJK330DqCg0GZIwa37IsCBlpM+RTAnTfOzi6a7CLShxLbcPjWjzsthVs3dXKw== ba1020@homie.homelinux.net" ];
  };
    
    
    
  users.extraUsers.garth = {
    isNormalUser = true;
    uid = 1020;
    description = "garth";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAuS8I7Oruq49An5XIDdSRl8SeEHQzq21hXitYtqPliysJuK45cBGdEGtXCm5B2zfWLaduE8tRn5+qw8HPWO4vNSaLKBy1+oQ06Qnn0qYApeF5si0dZ/KVE0YGUPA3EsGVq8YoXUqKNU/ALEJ2g+2B7nyaE2zjOunHtAU8l/Di1mYKjz5ed2S92nvaeWjnaZkN2FwZDJbDZLtd1xga424p6mJ5NyWW9kJ4lygHekQ7PItHOXvgrLAiWIJfK0XfZLfhdeHiZAjokR9LaaOqcMnnHmVC4aJWO9RW6SLzu2HUcTNsCvl+4O0wW5gZs9+yZCwkkpnqAGRRy8uYvSYAYgdsGQ== garth" ];
  };
    
  users.extraUsers.bhaveshmunot1 = {
    isNormalUser = true;
    uid = 1021;
    description = "bhaveshmunot1";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCycY6ljFkpQr4QkW0FFS1sjrxoP8I+CfVy0/eB4KWXxxKMzVQQmiVt03cHhBMxbS/Ioy/qncPb85HlcOjob/V2zJwpxXzwfhg8YLIbTAVVekEGlw4oaCi35mGlXKPUPGPXZK2Sg0HajwJ5rI9dEn4e0jrkaIsPZrO4qkw4KRrzTg/o429e0TCQrBBBxFxAhCgYJgcBIaQJniyVUepPlaQyVpvoQ5rh/IAzzfNFsrEYYnlwJlVtgPlmt4RqJYZAeLp7uFJNov6T6SK6L1XhFbumD1aiwL+/NY6sj0aJ9QZ0rt3FJ6l6ctUdEeaae1aMIskFWcA3h1Sp+Luu3NxsCDH3 bhavesh_munot@bmunot" ];
  };
    
  users.extraUsers.wingo = {
    isNormalUser = true;
    uid = 1022;
    description = "Andy Wingo";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAniIBKe3+toYN/4MtEnN8osjwkrlYlXfdRU1vXtjE1MRbPyiQ2D1MVFx6VWRz7VAKXToUeRqAqSm5jS+34r5erKbNGJnRcyOjryyDGCvwAHcVeAg0dbR75uwesw+0Bymhqw8CSCjauySWusMmB1is6Bow7G+tv9I91Pkky1WrgYu/JQDRpN00GCGbhrS2h2JaqIlgXRuzj9/ls8iJnPDNMi1qGoQBWXOhPFxURZMBPdUgFQeayQ96NvZdSHDlKCEgv9Nu1zvfpKsR34gwuC/V3/+DRvsRERXb3gLRQaZAPEAkAn/Qwu/SAMe7shgdKRiQqnpNsDGRWHCVX3E7QpSjqqmfbWaoKG1MITmm+4B/b+OWNThANCNxmkw+YSgqPnXcwfot5pBNGL/2MwdYLr9shidRrd2s2Sy+vLdaBlaaKSMuCIWt3JtVmj+yxXjJmHrnaj+oiNLTI/++La52smRgU9mk+0888Uz852p9WjeQ9C3dd07sdx96pGWDSkmUmoOaLxyn1ypIm5PvOoSZXs9/82sE5JUPmlVgPr9mF2vDYmydAo56uk9qUXD/4pdddzlWfmldsIoo4cAYFG+4tTcwOG/6TDeSWv0sS+9Gw1BBGvYLMpXBBn8TtRRt+jEDyvV2u7U5VK/h/wcPIVyiVXQkdOrkAOC3THVb8CUo+yWevHU= wingo@harpy.local" ];
  };
    
  users.extraUsers.dpino = {
    isNormalUser = true;
    uid = 1023;
    description = "Diego Pino";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCogIewHPhYyqgNzfq4sIHY64EZW+qjaZUnTzwcsMkRVrgUowjnDOKpfcWVwhY7vf2q7dVt9WZAjFLqhz712RwfqWOxkGVkqdLV/7CjMnXfcnGIhof5jxfp8w11cE6S8SBFep4sS5iVoFB6QumIaC0TLiWXyYPYL5r5WpwZJPhdsvmfpTGiw7O04Nb/VC1V5m3VsRKa/Cc5huLsP4VXECG9nXQXzGemezC5T6+pKq8rk+QHQ7O7Z7o82aAKVqWk2Tjg8RiO1CnV5Oh7NPn2xYTN2ftBEnQPb/Nqu74WTjdf0NWMMnlQfeUytpElxI9WbINgOVn2uDMBK8Odn0pao2wb dpino@tanimachi" ];
  };
    
  users.extraUsers.tupty = {
    isNormalUser = true;
    uid = 1024;
    description = "Tim Upthegrove";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0dHfnl833X43u1sSVX4gvS9P6sCpuEbYznI0fVzhN4a9cL4TY+zQJpE4rskq1ITdoAR66dazsLnddyGSLjY8zWpU5NfHjactB9h9AOTgVTQxZbpPROcn+KNEC63p4EzncqgHScWJsWcYPPsb2LgGGD0Hwhm7vmK22vaif2tob8v3OZ81U2a9icjWbK6tACIhrWIR36h0x1FXln8rTcftGs5zZPC2QpV6+7w4EtRXhO9jilnP1WMC0AuhydeInDzWi6+84808uetETu/3O9f6lvCO0hgKUiA8u8rjQyVAIhWmz9yLbkPo11Iba4laLatpjmWHCKVTJxsHniY9+zdyZ tupty@weentop" ];
  };
    
  users.extraUsers.clopez = {
    isNormalUser = true;
    uid = 1025;
    description = "Carlos Alberto Lopez Perez";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjPKdDymf+ylGtgVdx91Gd9k4I0UxEY/Q3o9gPTwFNpwlaxuCQoWf4QYym3xnkBQDqG+vj8wC07FfsMhEihp6CuUod1kddTXP5XiXIOzH1VsiuFh6ArcE3+FzJ1c2p68iv7rA8XHjAj47z9DcX1oCDQK0k36PRxvHs156YxyMSJmAGdvhC2welJ0RN2of6b0HLpVUqjHFT0nesFrlTDrybP32oBPrCcJANH2Be+7vXsJwKs9sg7rWvvkT+jez4cUxM+BghbZL+ERtq7Q6BcZG++oln/xJLXRBXjZ61gShVc5kl+MwZpW207m5jc87PknI7GUws09otNMEEfU+26JGN clopez@igalia.com" ];
  };
    
  users.extraUsers.kbarone = {
    isNormalUser = true;
    uid = 1026;
    description = "Katerina Barone-Adesi";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgt4ztMlTuVViA1Zco84FkS93/7fLX1QyAflFWGZvqhLYZNfJgeB5qHGcUfExl42+U5e0/Vu3l4KbBZJwlJS7xyzFu2mnKrcGSxg4JfCAzJWlWLBc4ATKYiCfZaZ/mqQOkLKNP/L6OCkcJlH0MFCko/u/eR1yKRmFzZ7jAv6iV2qj7XyjueJiDgoeQa4v/S4GneWsevnfoqBsjNRdHC2DnRV4m/dnzVTaSDWUjwVrSBnJ2liJzPeblNxdxy50Jxb5RQlMln0bVzJzUh/hDK98czPjxqRQYHzkXlNjqeExZhASIposZjSOL43VU17L1FqZz7xglUdWngzo/f2ZgXYy9 kbarone@igalia.com" ];
  };
    
  users.extraUsers.roicostas = {
    isNormalUser = true;
    uid = 1027;
    description = "Roi Costas";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFNL6QdF65WetRIPTq1uw4t/RZrHB41T8+URbTWEqh7ffrKVc3KyHXn/CgsdhIuh1PDztyPhuJh42JJOPwlQ0ihh6aQsPKsiC99Y07wJwQcbYGWryTG1ZUV1gWKbW/+smbZx6n2yZUlhlO1JnjHA6tCPOU42+pGlNjVwKArIyMn8ppNW5bCU6u9WMpnlOBLJwR96yHDnJJJdM/3ZHan/Z88xqkxQr3T6MNH6TB/57jItJo/y8vg2s9V9n82vIkGHBkipVBbvXpA717oz6+6c5Vap+7C+Msk2Lvkxgma/YoUYfzHxD+vnHbaAvm9QYthRaDJw9GC4jiQN4DbPYYEy7V roi.costas@torusware.com" ];
  };
    
  users.extraUsers.kll = {
    isNormalUser = true;
    uid = 1028;
    description = "Kristian Larsson";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBALjEzP27RrNkAs24cYqErHL4q8qQAODY3jFSgsXzCKk9IbEDlW8gd/5japWWQhfA9UdwncCWjVbBOWq7yEg1OTMgapD9cTJcUIoAwBRVPQwdoy75prTFFBfXjK4Q+QXE7cvRFmyou9ZcDJ5YRmXeod5By+i7ahQOF1EgPfk0EcrLAAAAFQDLNiY8d7jDL/MOZnCJneiKXFpSMQAAAIA9S+4JjcsqYbMaIV6PVapg7Ag8TSmhlBokWewY9xYPV5R+ct7LPZUiSxjxCF3DkN8+dg8M5vnoCfe1LoyD8M/Tr+iulTJbjSigW7WIKQpmwCAQ3ZZh+TUsENAmSWaKSxYHOiAqjs0OeDluKgxTYETgsoZT1eFt7xBChsJheY4HggAAAIBMcGyfNfaFv+/cXNiyxsM8IwbsEcRsmbp1Q5IhJ9efJwtO2kbWsxX79UgQgRwWVAT2eXDw/KPJOA5s5FSYS4EPhryIuKhDq1obS8FZn9Nkkxs6wDpDmTjk/5+xxJ0M7V4D5UEFCxMLeS7P68fM0Y3T5J3/EgtcrwvOUEAE919hLw== kll@spritelink.net" ];
  };
    
  users.extraUsers.vipulrathore1993 = {
    isNormalUser = true;
    uid = 1029;
    description = "vipulrathore1993";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDakrgG/Yig1MoZ40qklkC4HYu16BAU8OtxUeGLf1BQ/OIChDx2LWvov34iCXe3MgifUXYUKAalaMuGnZq/FU11k5ceugI5ykYa6jfwO6b0ZEOc6Bzr62RfTdNx3UJyXugX5Yy5KtwH1BalDdVQrsjI3XoU3mvGE0rNe4Fre271hWBko4R1qkCkbPKmZzGJaexxOL07qpfJLVdJ10BY1etoVdfCgt07ocozxLSd/WLsTZoserjmxYQn1p20kDHMhpi0GrzqTwYN5lnYekDZAxzzjVs7VGhVQYHdPh3MDOgSsrrEUt672NVZOr1SHPlda7YUBF69h1wO+Ajn48AxTeo7 vipulrathore1993@gmail.com" ];
  };
    
  users.extraUsers.hcnimkar = {
    isNormalUser = true;
    uid = 1030;
    description = "hcnimkar";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCV3IRHtAzI/20cQzJVv34AjBfTq8Q/+irCdScVSdmcmyaycZYTiBDuo4N6rcTCvLtoxrS6+vzPpcHKNLeUYJ8HzlGbvcwfHBMgpvpRdFcsp26Y2SKwkzVoHZzEEaRHfBaxEZweTRtFm8fOIoG33Pqp2Vi86BwmjyV2AyRyT/mRcAooKN34TSJ2GGKoSNV+sT+931DnUuuUy0kFtPr12bFZMj3/9uShLAE5G3UhdWNIFSXXej+97gKF0IOugfelMTbOAMiDLAgazgOHhPczlm1dE1pwnJh3k+neIlJwBS6WZ3g00+4QesSxpufTU0C/w0QDEGTQMphf2bO5t2QRVbgt hcnimkar@gmail.com" ];
  };
    
  users.extraUsers.alexkordic = {
    isNormalUser = true;
    uid = 1031;
    description = "Alex Kordic";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQB3K1YEfoajRCiNLN6zBcf/zD2ZV4n+B85pjnPu6WeRO6E2fG2ea8TVSzfrhPICG4TIbX2C5hlo7UG1YBfl+tc3kktJqD0QsEZZnQC8KgFfM2mvl71svK0YxUoGQF30qKqpEVvmveG6o97iM7om7kMiplb0RTA9qlGekBg1/4Jxtlxn7qinJ1VL3cfj5hV7Cgs2dFF5c9+5A/Ymfrywmi9uamtiGRwDvb583vZyoaR3X2Z+GCb8WJsEaKnSQ/jQUrkO1H7ZQo2tuKk/8LLGR1SlzkQckQZLdq/j8oVwanp9zyCi9ZqoKya+/pueHvRzQ855kahFQb+zpPshoP49Oyft alexandarkordic@gmail.com" ];
  };
    
  users.extraUsers.anton = {
    isNormalUser = true;
    uid = 1032;
    description = "Anton";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/53hJg7C18k0ATXzPp0E27pXdBa8/TpIE0zSad9C174wJGdcQNj/Pk9LwRCa6lNNGlDKB0Y3aQ0X4eSg05ZRnDwwnZFeSPQMTzpGiruqMWx4KQuHP64YnOYKiXol/kj6CPExb1ga/CLOG7e12efTqh/mJtg3LtW3f3j2j+DNvj3ErLN/U0Q9NlQviAPA0rKReJ68c65/1SgS1JUMeCoYXbLV1x6LFllIELpJct1+WN3qc4B4a83qaOGtQfharhOWeI0IFOX0p08I2Z7WPgwF2FlKBlPpYl+3gIBo0CPxV4ibJZY148lQJNIT7PmP/zcF6D9TAebuJoIp5jOmsCo/3 anton@ubuntu" ];
  };
    
  users.extraUsers.yyang13 = {
    isNormalUser = true;
    uid = 1033;
    description = "yyang13";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDnwgQj+22dL8jW4IVQvrAJFUuA58wEdSebQ6/Ap8NP0ju6YWoSo504+zJfxL3yfy+1Kl/EkLCLR0/YFGGMHS7CtpPv67IKkn7NZAwfTNGDPQodT9exFz8lhT3PjBtuSgyXZin4vwMytAtCIfgengXjrFqJkq/q+efGvSmX9Y2tUXoiE7Xyu/+PBt7MBqxawZbON69XIkomjoo4eUUO48kyEhsGL3zpIPiBGHltpHVcnbNut9fMHQjynqaM5kB+3H6VFUKb1F1Q3PVGSLvwM/Hfk2pvOi9fyvrIig6D2cjl/+OsCdQkveeY0/p6fY9ThnUu/h3w+kcrc8XFVLkPnYX" ];
  };
    
  users.extraUsers.hrushikesh = {
    isNormalUser = true;
    uid = 1034;
    description = "hrushikesh";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPC06uSKYm6OCMhPUnVY3ACY72rtKSHIEP7ltC0kehQZTXHs2/62P8Qx5xp2jHZsEhwVNYEnbmktElwRWz+FAr04BQYGCoBriJ6g4NsNuoSRIZvAdXUSjLNn2kOK98nXGmAiqEL7K9PIJAHx/ALhQ9KZC8Hc1ZtZrE/rUgyuqe4R39K3mLeFRahhPqEfEwUFAdcONYaCgrekpjzrOLKMarxZo0rxj4qj9HztQUQ07ABQEoV211jj3BDryMoyxjbGLVVHxhObQ2rR/2ft3Jys5uIg0yi2nxfBJJmU6tsdQd9VJCq4/g7ugNpPOncmP6SNpiAMJ1WCBWhNrmJ273Byt5 hrushikesh@hrushikesh-host" ];
  };
    
  users.extraUsers.saish = {
    isNormalUser = true;
    uid = 1035;
    description = "Saish Sali";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAojLRy4jjbQ9d2lp3UieKs832j8SACUVoLIlE7mB9+MaXSptSYt4Ucey+Bz+0NaNX1JISBd1D0tF+AQM7Rlm6J0p6G/37sNqarEJzKpr8gH1tEpwt6lsebdRzSY91jxwAMmBtUJgt2BufVnLLeLs7sxJr3G43e2R8CgoSYQ5OUCXiT2oV1+m+0LzWs021gqjmrhykvG6SnEn6MrmaSH/6qSEc75mJXaeiZOzWMpncrSav0SpIM2D0nnq9qxwOwusJSmPGPMMC71VvEmP+hR6DE7bKaqW/KNqyRK3q1R/22uZvr0wQ95E8UutRVjg7vNU7rgm+Xr+u4SXfX2iGdLK7 saish@saish-Lenovo-IdeaPad-Z510" ];
  };
    
  users.extraUsers.hans = {
    isNormalUser = true;
    uid = 1036;
    description = "Hans Huebner";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBALCWUTxnJiWIwo3sJlF8WVi78Qt4lNzeC1rE8ioTseMvt76PSPBePq7M/W8jJurhSVQG79D3/+CNmHmgXar0ZpHCwiRBZyipCpqf8bVCytI2CGKT+tMGbjaxLdNIDt+9W+xInv31AaNWdUx7huVRlq6unbGqKWwtUfzbQX8HNWnbAAAAFQCS7+N4ZDLdCGAxpLOY+JBUz90N8wAAAIEAphrgNktQlYQTUzopnmy96bzkMes8QmdAjWSVvm6yce/uCpmguo0HODHb0Az5GCgLBSaDFnjbaQ3jcqQ2PoH6zgzdbPanwpcrjy7/cishhGEZWj9dryvvEUdmls356IVfiRjUF5ZxLyhLvwkGoLI8aUaXaRIGd88oe39O/8XderEAAACATVVl/MbtbjkvGV1nnGpYW+D0v7OvS6v6x0gknw0z5cZSyjjnAwAQ9yrxaLsIE5BSGTPdZqxdSSosQWwPRwNZXeZj8IKHbQOMfkhdws8ez2JinJ2Mgm2hrtN0IJQOZ5ICP9ER1XoaU/EOT4ib/vpYLYSOkpEow2LCdBl08mopiSY= hans@huebner.org" ];
  };
    
  users.extraUsers.daurnimator = {
    isNormalUser = true;
    uid = 1037;
    description = "daurnimator";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAzg8e0cW4io7PVp+ID/f8wHldye9eMXv3wwp1TRpoL1yvqkXkou+ri4dhk2sZ85wfrFQKG13eY4LXYsPGlBjkrio5H11/dEzTGM5VkVnHhEmE1zV3szV3vf9zdQfZ0LPyNkeOf+Mec1olDgpMnLLv+zb7CIqGEzRvZT9dYTfiVtRizNGAq9PB+V3cNcA325WFQwx0o9FZQCbvyvI406oWk7NWLBv9/2YcMNUtsuzvF5ErF5W4wHuk1rEhavwPTW/r5O/97C1USrMdAQVS5AepLEWjlp7YUG43wygTLY6lk1m6oYd6FcILyjKzUIbdvBWnlTSbxaiyM5gkIGCgMcDv daurnimator" ];
  };
    
  users.extraUsers.liuran2011 = {
    isNormalUser = true;
    uid = 1038;
    description = "liuran2011";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqb4RqdSdDPM6A20l2aXjG4v9K99ogsr8lpBGHHl7V2Ek00mrS3bS4sCbvp3YfUFNMZfz+8Fbbl/KIJJngISAw4QTcLMPoUSVfm0H23neJ+LeJjfC6WFlF1orXuTothBjhXvGmEUnpdjfMdA+qNDGNRaVxKBrlCQR1j3JtBzPKBSk/4tAKotOfNmiQlzWPCU7Ea7f96m4I5kimgnuUcFQvhSR+t37JYMeTPu/e3j/nuzVf8dk0yeCHtVvw9CiT7lhho1B/9bM999xDR4scOSBWna2rLrFECn7Ao2d/PoQ5wZE2DRyfXRtonH053VE15Jpc+LJI7VOWXnFONWym8Bu7" ];
  };
    
  users.extraUsers.sm101 = {
    isNormalUser = true;
    uid = 1039;
    description = "Stevan Markovic";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmUqhU3Eg6zPJ8MEKpCcBkYRHXd/FVBxmy0DOj3GD5Hdxd/+cBDk/mfIJOy+r4HG2qQJBls9EvvZzcSnF3mqqURfWUDfKJ+fNZ+0vdeTodmgHiOERO5pUyf4h1YxqbxX+cVfELxpPwkGjtWIsvdt+CKuQ1b1rauKgv33YVkm1VJHCBJk8mh/JN5jsplnyu0nR5sPOJQ8rnDOr3vRGa0nGc+G7S03bAUBTmgjbEsRUOG2TJ1TPmkXoCVlR1I4yWUmgSMiKAO8nOFEwQaOQbLhLsvcYF7T4KzF86BUIG6hkm3qfHLPCmdbOfXfFnp8oNZiBq/S0nrHMLT9BGXjfXdbGv sm101" ];
  };
    
  users.extraUsers.kellabyte = {
    isNormalUser = true;
    uid = 1040;
    description = "Kelly Sommers";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIYvOmMBJniB7gPN8wO5Fla2JpuWZSUdhkE6IengiKLB9H/fS7Uu5GoT94CHOa5gg891eeM/MRDNGW+C+9x5UWbOiioaZoICQ9/srnSGHEHranTUL/z6AAJIhfRk+aeTdu7HI+wZv8ukMLWPyfsAAEcLQAK0tD0Nq8xqez5XloumASqzV1mPb0hHWlGw/Wx/Z+FJwfpvBkKULwWzD8kzFQWCBXlsk9vvQKgT4QBCXIjsvvAUhQLkkrXJI1Zi8G17zimcCS1TxEv9VPcf9vqTR9JtDawVtJZFIrSoi9SYDAoiZtR0RQ5dttbcL/IA+IFqBrRPygSLPC5Up9B7MEJ8Sj kell.sommers@gmail.com" ];
  };

  users.extraUsers.mwiget = {
    isNormalUser = true;
    uid = 1041;
    description = "Marcel Wiget";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3NzaC1kc3MAAACBAMdlCk1NNT2O+np4uzFWFDHP+zTS8uAC6c0mv2miSgAgJxFyfZpJH+HbOuLALCoyPrQbAPb+yPeXvl7xQwAUd94QW3dsX8B70skaxGQMXJdvEu3iDSnpxdeNMW+Ctl4JDHwNoZ93dCxqUqiF5tIE9ock8r1vEZ4d4Xy/LWe+mneVAAAAFQCZ3YEG7uDAfKRxcIK7v4XJyCknCwAAAIA4l8xAexLrEiheg8w8YYGvTtTV20xDaFObLI0fWFpYM0n6g80xkGoM409/1ne6PPqOydCp6dfNcbqf2vCq2WxffjEetMSE5BNk02JctdafO8wiGVFnQd39I+n70SCU/48s/NX+RqWcRgTlwDzp034ZiclDrmrBGVmz5TAJWXT8BgAAAIBbYv/+kxyNdM0HLiQn6/ShTCqK6gkhumDn3a/SS0nHx3LpdlACX9x49a7VTf4tYqctW6LUkE9ei0cvsHWq2ec6Q00UAypCaTtwUjt7vr7HmwuTKV6XOsLkupnEED5jtRgeEz5fuWPIMH6Xg/GENJ5z7N/6AlaOz3Emu6TQtkdwPw== mwiget@mwiget-mba13" ];
  };

  users.extraUsers.nnikolaev = {
    isNormalUser = true;
    uid = 1042;
    description = "Nikolay Nikolaev";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc87+h/CtgYjY0YIVqOAoqSCSmRdBevs1VecbZiw3u7HT4MkKEvd7ycP33eDYEL+pkMtEI7FVwZC3UoQCfEX1Dhu4TODzOUimgDawAej7dDYQ++K+3jUahDjnh+PmowTd9VTO8qjRJpJrsEuFBBOjK4p59H7VEh2JO08XZgrB4hk1NKgL2Jbal6zps6j6+gj5XvEjROOE5U66YXZSfD/pesvhId/XrQTs5baXSvF1d+Hdl7iKMsB6u/8i/g/+Xh9yPlgIrPw1d4q4jiQ1uKvtIGybhBjTRkIzD+RSfRyNpn4spFlT2keCtsUT1pBdg+0Bos3PT8oC5qxeLlOjAKDiL n.nikolaev@virtualopensystems.com" ];
  };

}
