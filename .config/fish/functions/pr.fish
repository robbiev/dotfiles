function pr
  set repo $(git remote get-url origin|sed "s/:/\\//; s/\\.git//; s/git@/https:\\/\\//")
  set branch $(git rev-parse --abbrev-ref HEAD)
  open "$repo/compare/$branch?expand=1"
end
