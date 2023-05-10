import Config

config :buzzword_bingo_live,
  player_colors: [
    "#38caf6", # picton blue
    "#a4deff", # anakiwa
    "#f9cedf", # azalea
    "#d3c5f1", # moon-raker
    "#acc9f5", # perano
    "#aeeace", # cruise
    "#96d7b9", # vista-blue
    "#fce8bd", # banana-mania
    "#fcd8ac"  # light-apricot
  ]

config :buzzword_bingo_live, game_sizes: 3..5
config :buzzword_bingo_live, max_players: 5
