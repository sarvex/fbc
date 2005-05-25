''
'' This Code Was Created By Jeff Molofee 2000
'' A HUGE Thanks To Fredric Echols For Cleaning Up
'' And Optimizing The Base Code, Making It More Flexible!
'' If You've Found This Code Useful, Please Let Me Know.
'' Visit My Site At nehe.gamedev.net
''
''------------------------------------------------------------------------------
'' Use ESC key to quit
''
''------------------------------------------------------------------------------

'' compile as: fbc -s gui lesson17.bas

option explicit

#include once "GL/gl.bi"
#include once "GL/glu.bi"
#include once "fbgfx.bi"                   '' for Scan code constants

'' Setup our booleans
const false = 0
const true  = not false

const TEX_MASKED = &h1
const TEX_MIPMAP = &h2
const TEX_NOFILTER = &h4
const TEX_HASALPHA = &h8
'-------------------------------------------------------------------------------
declare function CreateTexture( byval buffer as any ptr, byval flags as integer = 0) as uinteger
declare sub BuildFont()
declare sub glPrint(byval x as integer, byval y as integer, glstring as string, byval gset as integer)


dim shared gbase as uinteger                      '' Base Display List For The Font
dim shared texture(0 to 1) as uinteger            '' Storage For Our Font Texture
dim shared gloop as integer                       '' Generic Loop Variable

	dim cnt1 as single                            '' 1st Counter Used To Move Text & For Coloring
	dim cnt2 as single                            '' 2nd Counter Used To Move Text & For Coloring

	screen 18, 32, , 2

	'' ReSizeGLScene
	glViewport 0, 0, 640, 480                      '' Reset The Current Viewport
	glMatrixMode GL_PROJECTION                     '' Select The Projection Matrix
	glLoadIdentity                                 '' Reset The Projection Matrix
	gluPerspective 45.0, 640.0/480.0, 0.1, 100.0   '' Calculate The Aspect Ratio Of The Window
	glMatrixMode GL_MODELVIEW                      '' Select The Modelview Matrix
	glLoadIdentity                                 '' Reset The Modelview Matrix

	'' Use BLOAD to load the bitmaps.
	redim buffer(256*256*4+4) as ubyte       '' Size = Width x Height x 4 bytes per pixel + 4 bytes for header
	bload "data/Font.bmp", @buffer(0)        '' BLOAD the bitmap
	texture(0) = CreateTexture(@buffer(0))   '' Linear Texture
	bload "data/Bumps.bmp", @buffer(0)       '' BLOAD the bitmap
	texture(1) = CreateTexture(@buffer(0))   '' Linear Texture
	
	'' Exit if error loading textures
	if texture(0) = 0 or texture(1) = 0 then end 1

	'' All Setup For OpenGL Goes Here
	BuildFont                                '' Build The Font
	glClearColor 0.0, 0.0, 0.0, 0.0          '' Clear The Background Color To Black
	glClearDepth 1.0                         '' Enables Clearing Of The Depth Buffer
	glDepthFunc GL_LEQUAL                    '' The Type Of Depth Test To Do
	glBlendFunc GL_SRC_ALPHA, GL_ONE         '' Select The Type Of Blending
	glShadeModel GL_SMOOTH                   '' Enables Smooth Color Shading
	glEnable GL_TEXTURE_2D                   '' Enable 2D Texture Mapping

	do
		glClear GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT     '' Clear The Screen And The Depth Buffer
		glLoadIdentity                                         '' Reset The Modelview Matrix
		glBindTexture GL_TEXTURE_2D, texture(1)                '' Select Our Second Texture
		glTranslatef 0.0, 0.0, -5.0                            '' Move Into The Screen 5 Units
		glRotatef 45.0, 0.0, 0.0, 1.0                          '' Rotate On The Z Axis 45 Degrees (Clockwise)
		glRotatef cnt1*30.0, 1.0, 1.0, 0.0                     '' Rotate On The X & Y Axis By cnt1 (Left To Right)
		glDisable GL_BLEND                                     '' Disable Blending Before We Draw In 3D
		glColor3f 1.0,1.0,1.0                                  '' Bright White
		glBegin GL_QUADS                                       '' Draw Our First Texture Mapped Quad
			glTexCoord2d 0.0, 0.0                              '' First Texture Coord
			glVertex2f -1.0, 1.0                               '' First Vertex
			glTexCoord2d 1.0, 0.0                              '' Second Texture Coord
			glVertex2f  1.0, 1.0                               '' Second Vertex
			glTexCoord2d 1.0, 1.0                              '' Third Texture Coord
			glVertex2f  1.0, -1.0                              '' Third Vertex
			glTexCoord2d 0.0, 1.0                              '' Fourth Texture Coord
			glVertex2f -1.0, -1.0                              '' Fourth Vertex
		glEnd                                                  '' Done Drawing The First Quad
		glRotatef 90.0, 1.0, 1.0, 0.0                          '' Rotate On The X & Y Axis By 90 Degrees (Left To Right)
		glBegin GL_QUADS                                       '' Draw Our Second Texture Mapped Quad
			glTexCoord2d 0.0, 0.0                              '' First Texture Coord
			glVertex2f -1.0, 1.0                               '' First Vertex
			glTexCoord2d 1.0, 0.0                              '' Second Texture Coord
			glVertex2f  1.0, 1.0                               '' Second Vertex
			glTexCoord2d 1.0, 1.0                              '' Third Texture Coord
			glVertex2f  1.0, -1.0                              '' Third Vertex
			glTexCoord2d 0.0, 1.0                              '' Fourth Texture Coord
			glVertex2f -1.0, -1.0                              '' Fourth Vertex
		glEnd                                                  '' Done Drawing Our Second Quad
		glEnable GL_BLEND                                      '' Enable Blending

		glLoadIdentity                                         '' Reset The View
		'' Pulsing Colors Based On Text Position
		glColor3f 1.0*(cos(cnt1)), 1.0*(sin(cnt2)), 1.0-0.5*(cos(cnt1+cnt2))
		glPrint 280+250*cos(cnt1), 235+200*sin(cnt2), "NeHe", 0    '' Print GL Text To The Screen

		glColor3f 1.0*(sin(cnt2)), 1.0-0.5*(cos(cnt1+cnt2)), 1.0*(cos(cnt1))
		glPrint 280+230*cos(cnt2), 235+200*sin(cnt1), "OpenGL", 1  '' Print GL Text To The Screen

		glColor3f 0.0,0.0,1.0                                  '' Set Color To Blue
		glPrint 240+200*cos((cnt2+cnt1)/5), 2, "Giuseppe D'Agata", 0

		glColor3f 1.0,1.0,1.0                                  '' Set Color To White
		glPrint 242+200*cos((cnt2+cnt1)/5), 2, "Giuseppe D'Agata", 0

		cnt1 = cnt1 + 0.01                                     '' Increase The First Counter
		cnt2 = cnt2 + 0.0081                                   '' Increase The Second Counter

		flip                                      '' filp or crash
		if INKEY$ = CHR$(255)+"X" then exit do    '' exit if close box is clicked
	loop while not multikey(SC_ESCAPE)            '' exit if EXC is pressed
	'' Empty keyboard buffer
	while INKEY$ <> "": wend
	glDeleteLists gbase, 256                      '' Delete All 256 Display Lists
	end

'------------------------------------------------------------------------
'' Create texture creates textures from BLOAD buffer
function CreateTexture( byval buffer as any ptr, byval flags as integer= 0) as uinteger
	redim dat(0) as ubyte
	dim p as uinteger ptr, s as ushort ptr
	dim as integer w, h, x, y, col
	dim tex as uinteger
	dim as GLenum format, minfilter, magfilter

	CreateTexture = 0

	s = buffer
	w = s[0] shr 3
	h = s[1]

	if( (w < 64) or (h < 64) ) then
		exit function
	end if
	if( (w and (w-1)) or (h and (h-1)) ) then
		'' Width/height not powers of 2
		exit function
	end if

	redim dat(w * h * 4) as ubyte
	p = @dat(0)

	glGenTextures 1, @tex
	glBindTexture GL_TEXTURE_2D, tex

	for y = h-1 to 0 step -1
		for x = 0 to w-1
			col = point(x, y, buffer)
			'' Swap R and B so we can use the GL_RGBA texture format
			col = rgb(col and &hFF, _
				(col shr 8) and &hFF, _
				(col shr 16) and &hFF)
			if( (flags and TEX_MASKED) and (col = &hFF00FF) ) then
				*p = 0
			else
				*p = col or &hFF000000
			end if
			p += 4
		next x
	next y

	if (flags and (TEX_MASKED or TEX_HASALPHA)) then
		format = GL_RGBA
	else
		format = GL_RGB
	end if

	if (flags and TEX_NOFILTER) then
		magfilter = GL_NEAREST
	else
		magfilter = GL_LINEAR
	end if

	if( flags and TEX_MIPMAP) then
		gluBuild2DMipmaps GL_TEXTURE_2D, format, w, h, GL_RGBA, _
			GL_UNSIGNED_BYTE, @dat(0)

		if (flags and TEX_NOFILTER) then
			minfilter = GL_LINEAR_MIPMAP_NEAREST
		else
			minfilter = GL_LINEAR_MIPMAP_LINEAR
		end if
	else
		glTexImage2D GL_TEXTURE_2D, 0, format, w, h, 0, GL_RGBA, _
			GL_UNSIGNED_BYTE, @dat(0)
		minfilter = magfilter
	end if
	glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minfilter
	glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magfilter

	CreateTexture = tex

end function

'------------------------------------------------------------------------
sub BuildFont()                                  '' Build Our Font Display List

	dim cx as single                             '' Holds Our X Character Coord
	dim cy as single                             '' Holds Our Y Character Coord

	gbase = glGenLists(256)                      '' Creating 256 Display Lists
	glBindTexture GL_TEXTURE_2D, texture(0)      '' Select Our Font Texture
	for gloop = 0 to 255                         '' Loop Through All 256 Lists

		cx = (gloop mod 16)/16.0                 '' X Position Of Current Character
		cy = (gloop\16)/16.0                     '' Y Position Of Current Character

		glNewList gbase+gloop, GL_COMPILE        '' Start Building A List
		glBegin GL_QUADS                         '' Use A Quad For Each Character
			glTexCoord2f cx, 1-cy-0.0625         '' Texture Coord (Bottom Left)
			glVertex2i 0, 0                      '' Vertex Coord (Bottom Left)
			glTexCoord2f cx+0.0625, 1-cy-0.0625  '' Texture Coord (Bottom Right)
			glVertex2i 16,0                      '' Vertex Coord (Bottom Right)
			glTexCoord2f cx+0.0625, 1-cy         '' Texture Coord (Top Right)
			glVertex2i 16, 16                    '' Vertex Coord (Top Right)
			glTexCoord2f cx,1-cy                 '' Texture Coord (Top Left)
			glVertex2i 0, 16                     '' Vertex Coord (Top Left)
		glEnd                                    '' Done Building Our Quad (Character)
		glTranslated 10, 0, 0                    '' Move To The Right Of The Character
		glEndList                                '' Done Building The Display List
	next                                         '' Loop Until All 256 Are Built
end sub

'------------------------------------------------------------------------
'' Where The Printing Happens
sub glPrint(byval x as integer, byval y as integer, glstring as string, byval gset as integer)

	if gset>1 then gset=1

	glBindTexture GL_TEXTURE_2D, texture(0)                         '' Select Our Font Texture
	glDisable GL_DEPTH_TEST                                         '' Disables Depth Testing
	glMatrixMode GL_PROJECTION                                      '' Select The Projection Matrix
	glPushMatrix                                                    '' Store The Projection Matrix
		glLoadIdentity                                              '' Reset The Projection Matrix
		glOrtho 0, 640, 0, 480,-1, 1                                '' Set Up An Ortho Screen
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
		glPushMatrix                                                '' Store The Modelview Matrix
			glLoadIdentity                                          '' Reset The Modelview Matrix
			glTranslated x, y, 0                                    '' Position The Text (0,0 - Bottom Left)
			glListBase gbase-32+(128*gset)                          '' Choose The Font Set (0 or 1)
			glCallLists len(glstring),GL_BYTE, strptr(glstring)     '' Write The Text To The Screen
			glMatrixMode GL_PROJECTION                              '' Select The Projection Matrix
		glPopMatrix                                                 '' Restore The Old Projection Matrix
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
	glPopMatrix                                                     '' Restore The Old Projection Matrix
	glEnable GL_DEPTH_TEST                                          '' Enables Depth Testing
end sub
