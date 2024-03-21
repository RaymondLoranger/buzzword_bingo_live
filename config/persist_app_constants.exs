import Config

config :buzzword_bingo_live,
  player_colors: [
    # picton blue
    "#38caf6",
    # anakiwa
    "#a4deff",
    # azalea
    "#f9cedf",
    # moon-raker
    "#d3c5f1",
    # perano
    "#acc9f5",
    # cruise
    "#aeeace",
    # vista-blue
    "#96d7b9",
    # banana-mania
    "#fce8bd",
    # light-apricot
    "#fcd8ac"
  ]

config :buzzword_bingo_live, game_sizes: 3..5
config :buzzword_bingo_live, max_players: 5
