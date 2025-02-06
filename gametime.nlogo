breed [players player]
breed [balls ball]

players-own [
    ; Parameters
    number ; number ; 0-99 ; the player's number
    team ; "home" or "away"
    has-ball? ; boolean
    height ; number ; 0-96 ; how tall the player is in inches
    speed : number ; 0-100 ; how fast the player can run
    shoot : number ; 0-100 ; 
    pass : number ; 0-100 ; 
    rebound : number ; 0-100 ; 
    defend : number ; 0-100 ;

    ; State
    points ; number
    assists ; number
    rebounds ; number
]

balls-own [
    ; Parameters
    speed ; number ; for now, passes and shots move at a constant speed
    ; State
    holder ; player
    location ; vector
]

to setup
  clear-all
  setup-court
  create-players 10
  create-balls 1
  reset-ticks
end

to create-players [num-players]
  create-players num-players [
    ; Parameters
    set number (0 + random 99) ; temporary jersey numbers
    set team ifelse-value (who < 5) ["home"] ["away"]

    let height-mean 79
    let height-sd 4
    set height random-normal height-mean height-sd

    set speed 70 + random 20   ; baseline NBA speed
    set shoot 60 + random 30   ; shooting ability
    set pass 60 + random 30    ; passing ability
    set rebound 60 + random 30 ; rebounding ability
    set defend 60 + random 30  ; defensive ability
    
    ; State initialization
    set has-ball? false
    set points 0
    set assists 0
    set rebounds 0
    
    ; Visual setup
    set color ifelse-value (team = "home") [blue] [red]
    set shape "person"
    setxy (random-xcor) (random-ycor)
  ]
end

to setup-court
  clear-all
  resize-world -47 47 -25 25  ; 94x50 court
  
  ; Base court color
  ask patches [
    set pcolor 53  ; hardwood
  ]
  
  ; Out of bounds area (darker)
  ask patches with [abs pxcor > 45 or abs pycor > 23] [
    set pcolor 52  ; darker wood
  ]
  
  ; Court lines (all white)
  ; Center line
  ask patches with [pxcor = 0] [set pcolor white]
  
  ; Center circle (6 foot radius ≈ 3 patches)
  draw-circle 0 0 3
  
  ; Paint/Key (both ends)
  draw-paint 43   ; one end
  draw-paint -43  ; other end

  ; draw three point line
  draw-three-point-line 43
  draw-three-point-line -43

  
  ; Baskets
  create-baskets
end

to draw-circle [x y r]
  ask patches [
    if round(distancexy x y) = r [
      set pcolor white
    ]
  ]
end

to draw-paint [y-pos]
  ; Paint box (8 patches wide = 16 feet)
  ask patches with [
    abs pxcor <= 8 and
    abs(pycor - y-pos) <= 6  ; 12 feet deep
  ][
    if abs pxcor = 8 or abs(pycor - y-pos) = 6 [
      set pcolor white
    ]
  ]
end

to create-baskets
  ; Simple basket markers for now
  ask patches with [
    (pycor = 45 or pycor = -45) and
    pxcor = 0
  ][
    set pcolor orange
  ]
end

to draw-three-point-line [basket-y]
  ; Straight lines 3 feet from sidelines
  ask patches with [
    (abs pxcor = 22) and
    abs(pycor - basket-y) <= 14
  ][
    set pcolor white
  ]
  
  ; Arc
  let three-point-radius 12
  ask patches [
    if (round(distancexy 0 basket-y) = three-point-radius) and
       (abs pxcor < 22) and
       (abs(pycor - basket-y) < three-point-radius)
    [
      set pcolor white
    ]
  ]
end

to create-balls [num-balls]
  create-balls num-balls [
    ; Parameters
    set speed 10
    set shape "circle"
    set color orange
    set size 0.8
    set holder nobody
    setxy 10 10
  ]

end

to go
  tick
end