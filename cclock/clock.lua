clock_r=64
clock_x=clock_r+4
clock_y=clock_r+4

hh_color=0xffffff
hh_alpha=0.3
mm_color=0xffffff
mm_alpha=0.6
ss_color=0xffff99
ss_alpha=0.3

settings_table = {
	{
		name='time',
		arg='%S',
		max=60,
		bg_color=0x1f16F, bg_alpha=0.1,
		fg_color=0x91E990, fg_alpha=0.9,
		x=clock_x, y=clock_y,
		radius=clock_r,
		thickness=5,
		start_angle=0,
		end_angle=360
	}
}

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-- angle in radian

function draw_ring(cr,t,pt)
	local w,h=conky_window.width,conky_window.height

	local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
	local bgc, bga, fgc, fga

	local angle_0=math.pi*((sa/180)-0.5)
	local angle_f=math.pi*((ea/180)-0.5)
	local t_arc=t*(angle_f-angle_0)

	mm=os.date("%M")

	if mm%2==0 then
		bgc=pt['bg_color']
		bga=pt['bg_alpha']
		fgc=pt['fg_color']
		fga=pt['fg_alpha']
	else
		bgc=pt['fg_color']
		bga=pt['fg_alpha']
		fgc=pt['bg_color']
		fga=pt['bg_alpha']
	end

	cairo_set_line_width(cr,ring_w)

	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	if t==0 then
		cairo_arc(cr,xc,yc,ring_r, angle_0, angle_f)
	else
		cairo_arc(cr,xc,yc,ring_r, angle_0+t_arc, angle_0)
	end
	cairo_stroke(cr)

	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	cairo_stroke(cr)
end

function draw_clock_hands(cr,xc,yc)
	ss=os.date("%S")
	mm=os.date("%M")
	hh=os.date("%I")

	ss_arc=(ss/30)*math.pi
	mm_arc=(mm/30)*math.pi+ss_arc/60
	hh_arc=(hh/06)*math.pi+mm_arc/12

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)

-- hour hand
	xh=xc+0.6*clock_r*math.sin(hh_arc)
	yh=yc-0.6*clock_r*math.cos(hh_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(hh_color,hh_alpha))
	cairo_stroke(cr)

-- minute hand
	xm=xc+0.8*clock_r*math.sin(mm_arc)
	ym=yc-0.8*clock_r*math.cos(mm_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(mm_color,mm_alpha))
	cairo_stroke(cr)

-- second hand
	xs=xc+clock_r*math.sin(ss_arc)
	ys=yc-clock_r*math.cos(ss_arc)

	xss=xc-0.2*clock_r*math.sin(ss_arc)
	yss=yc+0.2*clock_r*math.cos(ss_arc)

	cairo_move_to(cr,xss,yss)
	cairo_line_to(cr,xs,ys)

	cairo_set_line_width(cr,1)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(ss_color,ss_alpha))
	cairo_stroke(cr)
end


function conky_clock_rings()
	local function setup_rings(cr,pt)
		local str=''
		local value=0

		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)

		value=tonumber(str)
		if value == nil then value = 0 end
		pct=value/pt['max']

		draw_ring(cr,pct,pt)
	end


	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

	local cr=cairo_create(cs)

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then
		for i in pairs(settings_table) do
			setup_rings(cr,settings_table[i])
		end
	end

	draw_clock_hands(cr,clock_x,clock_y)
end

