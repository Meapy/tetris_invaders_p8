pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

function _init()

	shots_setup()

	make_turret()

	make_enemies()

end

function _update()

	--loop through all the shots
	--and pass each shot to the 
	--update_shot() function.
	--this will make sure that every
	--shot moves or changes every
	--time the game updates.
 foreach(shots,update_shot)
 
	--move the turret if needed and
	--fire if the player chooses to
 update_turret()
 
end

function _draw()
 
 cls()
 
 --loop through all the shots
 --and pass each shot to the
 --draw_shot() function
 foreach(shots,draw_shot)
 
 --draw the turret and all the
 --enemies that are left
 draw_turret()
 foreach(enemies,draw_enemy)
 
end
-->8
--shot functions

function shots_setup()
	
	--create an empty table to hold
	--all the shots that get made.
	--new shots will be added to
	--this table, and when they
	--leave the screen or hit an
	--enemy, they will be removed
	--from this table.
	shots={}
	
end


--when the player fires, we need
--to make a shot and add it to
--the list of all current shots
function make_shot(x,y)
	
	--create an empty table to
	--hold this one shot
	local s={}
	
	--where the shot will start at
	s.x=x
	s.y=y
	
	--the shot needs a width and a
	--height so that we can detect
	--if it collides with anything
	s.w=3
	s.h=3

	--these are the speeds the shot
	--is moving in the left/right
	--up/down directions. since the
	--shots will go up each time
	--they move, .dy is set to -3
	s.dx=0
	s.dy=-3

 --which sprite to draw for the
 --shot when it is on the screen
	s.sprite=2
	
	--add this shot table to the
	--big list of all the shots
	add(shots,s)
	
	--play a sound effect when a
	--shot is created (fired)
	sfx(0)
	
end

--every time the game updates,
--we need to update all the
--shots, which means moving them
--and checking to see if they
--collide with anything (and
--then doing something if they
--do collide).
function update_shot(s)
	
	--move the shots to their new
	--position based on their
	--speed in the x/y directions
	s.x+=s.dx
	s.y+=s.dy
	
	--after moving the shots, check
	--if certain conditions are
	--now true, such as leaving
	--the screen or hitting an
	--enemy, or anything else you
	--want to check for.
	
	--if the shot leaves the screen
	--then just remove the shot
	--from the big list of current
	--shots
	if (s.y<-8) del(shots,s)
	
	--go through the entire list of
	--enemies and compare this shot
	--to each enemy to see if this
	--shot overlaps any enemies.
	for e in all(enemies) do
	
	 --if this shot does overlap
	 --an enemy...
		if (overlap(e,s)) then
		 
		 --first delete the shot,
		 --because it did its job
		 del(shots,s)
		 
		 --then run a function to do
		 --something when the shot
		 --collides with an enemy.
		 --this might mean destroying
		 --the enemy, or reducing its
		 --health, or playing a sound,
		 --or making an explosion, etc
		 hit_enemy(e)

		end
	end
end

--draw the projectile on the
--screen. this could be more
--fancy, like adding particles
--coming out of the shot or
--something like that
function draw_shot(s)
	spr(s.sprite,s.x,s.y)
end

--this is what should happen if
--a projectile hits an enemy.
function hit_enemy(e)

 --remove the enemy from the
 --list of current enemies
	del(enemies,e)
	
	--play an explosion sound
	sfx(1)
	
end
-->8
--turret and enemy functions

--the code here is not heavily
--commented because most of this
--code is covered elsewhere in
--the toolset.

--make a simple turret table
function make_turret()
	turret={}
	turret.x=60
	turret.y=88
	turret.sprite=1
end

--move the turret if they press
--⬅️/➡️, but don't let it leave
--the screen. and fire if they
--press ❎
function update_turret()
 
 --move the turret
 if (btn(⬅️)) turret.x-=1
 if (btn(➡️)) turret.x+=1
 
 --keep it on screen
 turret.x=mid(0,turret.x,120)
 
 --create a projectile if they
 --press the ❎ button 
 if (btnp(❎)) then
  make_shot(turret.x+2,turret.y)
 end
 
end

--draw the turret on the screen
function draw_turret()
	spr(turret.sprite,turret.x,turret.y)
end

--create a few simple enemies
--in a line across the top of
--the screen
function make_enemies()
	enemies={}
	for i=1,14,2 do
		make_enemy(8*i,32)
	end
	
end

--create a very simple enemy
--that just has a hitbox 
--(x,y,w,h) and add it to the
--list of enemies
function make_enemy(x,y)
	local e={}
	e.x=x
	e.y=y
	e.w=7
	e.h=7
	e.sprite=3
	add(enemies,e)
end

--draw an enemy on the screen
function draw_enemy(e)
	spr(e.sprite,e.x,e.y)
end
-->8
--collision functions

--this is a standard overlap
--function  we're using to see
--if projectiles collide with
--enemies. see the toolset cart
--overlap.p8.png for how this
--works
function overlap(a,b)
	return not (a.x>b.x+b.w or a.y>b.y+b.h or a.x+a.w<b.x or a.y+a.h<b.y)
end
-->8
--tetris code
function gravity()
    -- collision
    if( block_collision( m_x, m_y + 0.25, m_rotate )) then
        m_score += 40
        set_block()
        reset()
        check_endgame()
    else
        m_y += 1
    end
end
__gfx__
00000000008886660880000022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000067777668278000028888882000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700655667608228000028222282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000fbbfbb00880000028288282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000fffff000000000028288282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700004440000000000028222282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000f5a5f000000000028888882000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001010000000000022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000999900000000000099990000000000009999000000000000999900000000000099990000000000009999000000000000000000
00000000099999900000000009999990000000000999999000000000099999900000000009999990000000000999999000000000099999900000000000000000
00000000990990990000000099099099000000009909909900000000990990990000000099099099000000009909909900000000990990990000000000000000
00000000999999990000000099999999000000009999999900000000999999990000000099999999000000009999999900000000999999990000000000000000
00000000999009990000000099900999000000009990099900000000999009990000000099900999000000009990099900000000999009990000000000000000
00000000099999900000000009999990000000000999999000000000099999900000000009999990000000000999999000000000099999900000000000000000
00000000009009000000000000900900000000000090090000000000009009000000000000900900000000000090090000000000009009000000000000000000
00000000990000990000000099000099000000009900009900000000990000990000000099000099000000009900009900000000990000990000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000827800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000822800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000827800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000822800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000777700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000566700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000566700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000055666677000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000056666667000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000056666667000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000055555557000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
000600000d33102321003010030100301003010030100301003010030100301003010030100301003010030100301003010030100301003010030100301003010030100301003010030100301003010030100301
00050000080700607008060080600f0501104013030190101e0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
