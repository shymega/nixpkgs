{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
with lib;
let
  cfg = config.services.lorry;
  settingsFormat = pkgs.formats.json { };

  mkBind = cfg: "${cfg.listenAddress}:${toString cfg.listenPort}";
in
{
  meta.maintainers = with maintainers; [ shymega ];

  options.services.lorry = {

    enable = mkEnableOption "Lorry, a software asset mirroring system";

    package = mkPackageOption pkgs "lorry" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      description = "Listen IP address";
      default = "0.0.0.0";
    };
    listenPort = lib.mkOption {
      type = lib.types.port;
      description = "Listen port";
      default = 8080;
    };

    lorryHostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname to use with Nginx reverse proxy";
      default = cfg.nginx.enable && config.networking.hostName;
    }

    nginx.enable = mkEnableOption "exposing Lorry with the nginx reverse proxy";

    database = {
      path = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "The database file path.";
      };

      uriFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "File which contains the database file path.";
      };
    };

    settings = mkOption {
      default = { };
      description = "lorry configuration";

      type = types.submodule {
        freeformType = settingsFormat.type;
      };
    };
  };

  config =
    lib.mkIf cfg.enable {

      services.nginx = mkIf cfg.nginx.enable {
        enable = mkDefault true;
        virtualHosts."${cfg.lorryHostname}".locations =
          let
            backend = "http://${mkBind cfg}";
          in
          {
            "/" = {
              proxyPass = backend;
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          };
      };

      assertions = [
        {
            assertion = cfg.database.pathFile != null -> cfg.database.path == null;
            message = "Specifying a database path whilst also specifying a database path file is not allowed";
        }
      ];

      systemd.services.lorry =
        let
          substitutedConfig = "/run/lorry/config.json";
        in
        {
          description = "lorry server";

          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            DynamicUser = true;
            RuntimeDirectory = "lorry";
            ExecStart = "${getExe cfg.package}";
            PrivateTmp = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
          };
        };

}
