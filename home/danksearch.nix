{ inputs, ... }:

{
  imports = [ inputs.danksearch.homeModules.default ];

  programs.dsearch = {
    enable = true;
    config = {
      index_paths = [
        {
          path = "~/Projects";
          max_depth = 8;
          exclude_hidden = true;
          exclude_dirs = [ "node_modules" ".git" ".next" "dist" "build" ".turbo" ".cache" ];
        }
        {
          path = "~/Documents";
          max_depth = 6;
          exclude_hidden = true;
          exclude_dirs = [ ];
        }
      ];
    };
  };
}
