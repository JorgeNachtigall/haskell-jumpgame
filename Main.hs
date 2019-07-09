import Graphics.Gloss
import Graphics.Gloss.Data.ViewPort
import Graphics.Gloss.Interface.Pure.Game
import System.Random

width, height, offset :: Int
width = 800
height = 800
offset = 0

window :: Display
window = InWindow "Nice Window" (width, height) (offset, offset)

background :: Color
background = white

data JumpGame = Game
  { cactusCoord :: (Float, Float)
  , cactusVel :: (Float, Float)
  , cactusOffset :: Float
  , dinossaur :: (Float, Float)
  , dinoVel :: Float
  , dinoOffsetX :: Float
  , dinoOffsetY :: Float
  } deriving Show 

render :: JumpGame -> Picture
render game =
    pictures [cactus, wall 0,
        createDino rose (dinossaur game)]
    where
--  The pong ball.
    cactus = uncurry translate (cactusCoord game) $ color cactusColor $ rectangleSolid 30 30
    cactusColor = green

--  The bottom and top walls.
    wall :: Float -> Picture
    wall offset =
        translate (-400) offset $
        color wallColor $
            rectangleSolid 10 800
    wallColor = greyN 0.5

--  Make a paddle of a given border and vertical offset.
    createDino :: Color -> (Float, Float) -> Picture
    createDino colr coord = pictures
        [ uncurry translate coord $ color colr $ rectangleSolid 30 80
        ]

-- | The starting state for the game of Pong.
initialState :: JumpGame
initialState = Game
  { cactusCoord = (300, -340)
  , cactusVel = (-250, 0)
  , cactusOffset = 15
  , dinossaur = (-300, -300)
  , dinoVel = 0
  , dinoOffsetY = 40
  , dinoOffsetX = 15
  }

-- | Update the ball position using its current velocity.
moveCactus :: Float    -- ^ The number of seconds since last update
    -> JumpGame -- ^ The initial game state
    -> JumpGame -- ^ A new game state with an updated ball position

moveCactus seconds game = game { cactusCoord = (x', y') }
    where
      -- Old locations and velocities.
      (x, y) = cactusCoord game
      (vx, vy) = cactusVel game
  
      -- New locations.
      x' = x + vx * seconds
      y' = y + vy * seconds

type BoundingCactus = Float
type Position = (Float, Float)

cactusEnd :: JumpGame -> Position -> BoundingCactus -> (Float, Float)
cactusEnd game (x, _) bounding
    | x - bounding <= -fromIntegral 400 = wallCollision
    | otherwise = cactusCoord game
    where
        wallCollision = (300, -335)

restartCactus :: JumpGame -> JumpGame
restartCactus game = game {cactusCoord = (x, y)}
    where
        bounding = -30

        (x, y) = cactusEnd game (cactusCoord game) bounding

checkCollision :: JumpGame -> JumpGame
checkCollision game
    | (fst (cactusCoord game) - cactusOffset game < fst (dinossaur game) + dinoOffsetX game) && (snd (cactusCoord game) + cactusOffset game > snd (dinossaur game) - dinoOffsetY game) && (fst (cactusCoord game) - cactusOffset game) > (fst (dinossaur game) - dinoOffsetX game) = error "DEAD"
    | otherwise = game

fps :: Int
fps = 60

userInput :: Event -> JumpGame -> JumpGame
userInput (EventKey (Char 'w') _ _ _) game = game {dinoVel = 750}

userInput _ game = game

moveY :: Float -> JumpGame -> JumpGame
moveY seconds game = game {dinossaur = (x', y')}
    where
        (x, y) = dinossaur game
        vel = dinoVel game
        x' = x
        y' = y + (vel * seconds)

changeSignal :: JumpGame -> JumpGame
changeSignal game = 
    if (snd (dinossaur game) > -150)
        then game { dinoVel = dinoVel game * (-1) }
        else if (snd (dinossaur game) > 0)
            then game { dinoVel = dinoVel game * (-1) }
            else if (snd (dinossaur game) <= -301)
                then game { dinoVel = 0 }
                else game

checkPos :: JumpGame -> JumpGame
checkPos game = 
    if(snd (dinossaur game) < -300)
        then game { dinossaur = (-300, -300)}
        else game

update :: Float -> JumpGame -> JumpGame 
update seconds = restartCactus . moveCactus seconds . moveY seconds . changeSignal . checkPos . checkCollision

main :: IO()
main = play window background fps initialState render userInput update