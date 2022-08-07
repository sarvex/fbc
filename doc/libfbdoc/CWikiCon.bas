''  fbdoc - FreeBASIC User's Manual Converter/Generator
''	Copyright (C) 2006-2022 The FreeBASIC development team.
''
''	This program is free software; you can redistribute it and/or modify
''	it under the terms of the GNU General Public License as published by
''	the Free Software Foundation; either version 2 of the License, or
''	(at your option) any later version.
''
''	This program is distributed in the hope that it will be useful,
''	but WITHOUT ANY WARRANTY; without even the implied warranty of
''	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
''	GNU General Public License for more details.
''
''	You should have received a copy of the GNU General Public License
''	along with this program; if not, write to the Free Software
''	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02111-1301 USA.


'' CWikiCon
''
'' chng: may/2019 written [coderJeff]
''

#include once "CWikiCon.bi"

namespace fb.fbdoc

	'':::::
	constructor CWikiCon _
		( _
		)
	end constructor

	'':::::
	destructor CWikiCon _
		( _
		)
	end destructor

	'':::::
	function CWikiCon.LoadPage _
		( _
			byval pagename as zstring ptr, _
			byref body as string _
		) as boolean

		body = ""
		function = false

	end function

	'':::::
	function CWikiCon.LoadIndex _
		( _
			byval pagename as zstring ptr, _
			byref body as string, _
			byval format as CWikiCon.IndexFormat _
		) as boolean

		body = ""
		function = false

	end function

	'':::::
	function CWikiCon.StorePage _
		( _
			byval body as zstring ptr, _
			byval note as zstring ptr _
		) as boolean
		
		function = false

	end function

	'':::::
	function CWikiCon.StoreNewPage _
		( _
			byval body as zstring ptr, _
			byval pagename as zstring ptr _
		) as boolean

		function = false

	end function

	'':::::
	function CWikiCon.GetPageID _
		( _
		) as integer

		function = 0

	end function

end namespace
