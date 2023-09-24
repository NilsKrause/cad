// Font Functions
// Encoding from http://en.wikipedia.org/wiki/ASCII
// Author: Andrew Plumb
// License: LGPL 2.1

module outline_2d(outline,points,paths,width=0.1,resolution=8) {
  if(outline && resolution > 4) {
    for(j=[0:len(paths)-1]) union() {
      for(i=[1:len(paths[j])-1]) hull() {
            translate(points[paths[j][i-1]]) circle($fn=resolution,r=width/2);
            translate(points[paths[j][i]]) circle($fn=resolution,r=width/2);
      }
      hull() {
            translate(points[paths[j][len(paths[j])-1]]) circle($fn=resolution,r=width/2);
            translate(points[paths[j][0]]) circle($fn=resolution,r=width/2);
      }
    }
  } else {
      polygon(points=points,paths=paths);
  }
}

module bold_2d(bold,width=0.2,resolution=8) {
  for(j=[0:$children-1]) {
    if(bold) {
      union() {
            children(j);
        for(i=[0:resolution-1]) {
            dx=width*cos(360*i/resolution);
            dy=width*sin(360*i/resolution);
            translate([dx,dy]) children(j);
        }
      }
    } else {
      children(j);
    }
  }
}

module polytext(charstring,size,font,line=0,justify=1,align=-1
	,bold=false,bold_width=0.2,bold_resolution=8
	,underline=false,underline_start=[0,0],underline_width=1.0
	,outline=false,outline_width=0.2,outline_resolution=8
	,strike=false,strike_start=[-0.5,0],strike_width=1.0
	) {
  line_length=len(charstring)*font[0][0];
  line_shift_x=-line_length/2+justify*line_length/2;
  char_width=font[0][0];
  char_height=font[0][1];
  char_shift_height=-char_height/2-align*char_height/2;
  char_thickness=font[0][2];
  char_index_map=search(charstring,font[2],1,1);
  for(i=[0:len(char_index_map)-1]) {
    thisCharIndex=char_index_map[i];
    x_pos=i*size+line_shift_x*size/char_width;
    translate([x_pos,line*size+char_shift_height*size/char_height]) scale([size/char_width,size/char_height]) {
      if(char_thickness==0)
        bold_2d(bold,width=bold_width,resolution=bold_resolution)
          outline_2d(outline,points=font[2][thisCharIndex][6][0],paths=font[2][thisCharIndex][6][1]
              ,width=outline_width,resolution=outline_resolution);
      if( charstring[i] != " " ) {
        if(underline) translate(underline_start)
	  square(size=[char_width-2*underline_start[0],underline_width],center=false);
        if(strike) translate([strike_start[0],char_height/2+strike_start[1]])
          square(size=[char_width-2*strike_start[0],strike_width],center=false);
      }
      if(char_thickness>0)
          polyhedron(points=font[2][thisCharIndex][6][0],triangles=font[2][thisCharIndex][6][1]);
    }
  }
}


function 8bit_polyfont(dx=0.1,dy=0.1) = [
  [8,8,0,"fixed"],["Decimal Byte","Caret Notation","Character Escape Code","Abbreviation","Name","Bound Box","[points,paths]"]
  ,[
   [  0,"^@","\0","NUL","Null character",[[0,0],[8,8]],[]]
  ,[  1,"^A","",  "SOH","Start of Header",[[0,0],[8,8]],[]]
  ,[  2,"^B","",  "STX","Start of Text",[[0,0],[8,8]],[]]
  ,[  3,"^C","",  "ETX","End of Text",[[0,0],[8,8]],[]]
  ,[  4,"^D","",  "EOT","End of Transmission",[[0,0],[8,8]],[]]
  ,[  5,"^E","",  "ENQ","Enquiry",[[0,0],[8,8]],[]]
  ,[  6,"^F","",  "ACK","Acknowledgment",[[0,0],[8,8]],[]]
  ,[  7,"^G","\a","BEL","Bell",[[0,0],[8,8]],[]]
  ,[  8,"^H","\b","BS", "Backspace",[[0,0],[8,8]],[]]
  ,[  9,"^I","\t","HT", "Horizontal Tab",[[0,0],[8,8]],[]]
  ,[ 10,"^J","\n","LF", "Line Feed",[[0,0],[8,8]],[]]
  ,[ 11,"^K","\v","VT", "Vertical Tab",[[0,0],[8,8]],[]]
  ,[ 12,"^L","\f","FF", "Form feed",[[0,0],[8,8]],[]]
  ,[ 13,"^M","\r","CR", "Carriage return",[[0,0],[8,8]],[]]
  ,[ 14,"^N","",  "SO", "Shift Out",[[0,0],[8,8]],[]]
  ,[ 15,"^O","",  "SI", "Shift In",[[0,0],[8,8]],[]]
  ,[ 16,"^P","",  "DLE","Data Link Escape",[[0,0],[8,8]],[]]
  ,[ 17,"^Q","",  "DC1","Device Control 1",[[0,0],[8,8]],[]]
  ,[ 18,"^R","",  "DC2","Device Control 2",[[0,0],[8,8]],[]]
  ,[ 19,"^S","",  "DC3","Device Control 3",[[0,0],[8,8]],[]]
  ,[ 20,"^T","",  "DC4","Device Control 4",[[0,0],[8,8]],[]]
  ,[ 21,"^U","",  "NAK","Negative Acknowledgement",[[0,0],[8,8]],[]]
  ,[ 22,"^V","",  "SYN","Synchronous Idle",[[0,0],[8,8]],[]]
  ,[ 23,"^W","",  "ETB","End of Transmission Block",[[0,0],[8,8]],[]]
  ,[ 24,"^X","",  "CAN","Cancel",[[0,0],[8,8]],[]]
  ,[ 25,"^Y","",  "EM", "End of Medium",[[0,0],[8,8]],[]]
  ,[ 26,"^Z","",  "SUB","Substitute",[[0,0],[8,8]],[]]
  ,[ 27,"^[","\e","ESC","Escape",[[0,0],[8,8]],[]]
  ,[ 28,"^\\","", "FS", "File Separator",[[0,0],[8,8]],[]]
  ,[ 29,"^]","",  "GS", "Group Separator",[[0,0],[8,8]],[]]
  ,[ 30,"^^","",  "RS", "Record Separator",[[0,0],[8,8]],[]]
  ,[ 31,"^_","",  "US", "Unit Separator",[[0,0],[8,8]],[]]
  ,[ 32," "," ",  "", "Space",[[0,0],[2,8]],[]]
  ,[ 33,"!","!",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,2],[5,2],[5,1]
	,[3,3],[3,7],[5,7],[5,3]]
	,[[0,1,2,3],[4,5,6,7]]
	]]
  ,[ 34,"\"","\"","", "",[[0,0],[8,8]],[
	[[1,4],[1,7],[3,7],[3,4]
	,[5,4],[5,7],[7,7],[7,4]]
	,[[0,1,2,3],[4,5,6,7]]
	]]
  ,[ 35,"#","#",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[0,2],[0,3],[1,3],[1,5],[0,5],[0,6],[1,6],[1,7],[3,7],[3,6],[5,6],[5,7],[7,7]
		,[7,6],[8,6],[8,5],[7,5],[7,3],[8,3],[8,2],[7,2],[7,1],[5,1],[5,2],[3,2],[3,1]
	,[3,3],[3,5],[5,5],[5,3]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27],[28,29,30,31]]
	]]
  ,[ 36,"$","$",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,2],[1,2],[1,3],[5,3],[5,4],[2,4],[2,5],[1,5],[1,6],[2,6],[2,7],[3,7],[3,8],[5,8],[5,7],[7,7],[7,6]
		,[3,6],[3,5],[6,5],[6,4],[7,4],[7,3],[6,3],[6,2],[5,2],[5,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[ 37,"%","%",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,3],[2,3],[2,5],[1,5],[1,7],[3,7],[3,5],[4,5],[4,6],[5,6],[5,7],[7,7]
		,[7,6],[6,6],[6,5],[5,5],[5,4],[4,4],[4,3],[3,3],[3,2],[2,2],[2,1]
	,[5,1],[5,3],[7,3],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],[24,25,26,27]]
	]]
  ,[ 38,"&","&",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,4],[2,4],[2,5],[3,5],[3,6],[2,6],[2,7],[3,7],[3,8],[6,8],[6,7],[7,7],[7,6],[6,6],[6,5],[5,5],[5,4]
		,[8,4],[8,3],[7,3],[7,2],[8,2],[8,1],[6,1],[6,2],[5,2],[5,1]
	,[3,2],[3,4],[4,4],[4,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29],[30,31,32,33]]
	]]
  ,[ 39,"'","'",  "", "",[[0,0],[8,8]],[
	[[3,4],[3,7],[5,7],[5,4]]
	,[[0,1,2,3]]
	]]
  ,[ 40,"(","(",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,2],[2,2],[2,6],[3,6],[3,7],[6,7],[6,6],[5,6],[5,5],[4,5],[4,3],[5,3],[5,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[ 41,")",")",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[3,2],[3,3],[4,3],[4,5],[3,5],[3,6],[2,6],[2,7],[5,7],[5,6],[6,6],[6,2],[5,2],[5,1],[4,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
	]]
  ,[ 42,"*","*",  "", "",[[0,0],[8,8]],[
	[[1,2],[1,3],[2,3],[2,4],[0,4],[0,5],[2,5],[2,6],[1,6],[1,7],[3,7],[3,6],[5,6],[5,7],[7,7],[7,6],[6,6]
		,[6,5],[8,5],[8,4],[6,4],[6,3],[7,3],[7,2],[5,2],[5,3],[3,3],[3,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[ 43,"+","+",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,3],[1,3],[1,5],[3,5],[3,7],[5,7],[5,5],[7,5],[7,3],[5,3],[5,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[ 44,",",",",  "", "",[[0,0],[8,8]],[
	[[2,0],[2,1],[3,1],[3,3],[5,3],[5,1],[4,1],[4,0]]
	,[[0,1,2,3,4,5,6,7]]
	]]
  ,[ 45,"-","-",  "", "",[[0,0],[8,8]],[
	[[1,3],[1,5],[7,5],[7,3]]
	,[[0,1,2,3]]
	]]
  ,[ 46,".",".",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,3],[5,3],[5,1]]
	,[[0,1,2,3]]
	]]
  ,[ 47,"/","/",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,3],[2,3],[2,4],[3,4],[3,5],[4,5],[4,6],[5,6],[5,7],[7,7],[7,6],[6,6],[6,5],[5,5],[5,4],[4,4],[4,3],[3,3],[3,2],[2,2],[2,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]]
	]]
  ,[ 48,"0","0",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,2],[6,2],[6,1]
	,[3,2],[3,3],[5,3],[5,2]
	,[3,4],[3,6],[5,6],[5,5],[4,5],[4,4]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11],[12,13,14,15],[16,17,18,19,20,21]]
	]]
  ,[ 49,"1","1",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[3,2],[3,5],[2,5],[2,6],[3,6],[3,7],[5,7],[5,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[ 50,"2","2",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[2,2],[2,3],[3,3],[3,4],[4,4],[4,5],[5,5],[5,6],[3,6],[3,5],[1,5],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,5],[6,5],[6,4],[5,4],[5,3],[4,3],[4,2],[3,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]]
	]]
  ,[ 51,"3","3",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,3],[3,3],[3,2],[5,2],[5,3],[4,3],[4,4],[3,4],[3,5],[4,5],[4,6],[1,6],[1,7],[7,7],[7,6],[6,6],[6,5],[5,5],[5,4],[6,4],[6,3],[7,3],[7,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[ 52,"4","4",  "", "",[[0,0],[8,8]],[
	[[4,1],[4,2],[1,2],[1,4],[2,4],[2,5],[3,5],[3,6],[4,6],[4,7],[6,7],[6,3],[7,3],[7,2],[6,2],[6,1]
	,[3,3],[3,4],[4,4],[4,3]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],[16,17,18,19]]
	]]
  ,[ 53,"5","5",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,3],[3,3],[3,2],[5,2],[5,4],[1,4],[1,7],[7,7],[7,6],[3,6],[3,5],[6,5],[6,4],[7,4],[7,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[ 54,"6","6",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[6,7],[6,6],[3,6],[3,5],[6,5],[6,4],[7,4],[7,2],[6,2],[6,1]
	,[3,2],[3,4],[5,4],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],[16,17,18,19]]
	]]
  ,[ 55,"7","7",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,3],[3,3],[3,4],[4,4],[4,5],[5,5],[5,6],[1,6],[1,7],[7,7],[7,5],[6,5],[6,4],[5,4],[5,3],[4,3],[4,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]]
	]]
  ,[ 56,"8","8",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,4],[2,4],[2,5],[1,5],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,5],[6,5],[6,4],[7,4],[7,2],[6,2],[6,1]
	,[3,2],[3,4],[5,4],[5,2]
	,[3,5],[3,6],[5,6],[5,5]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],[20,21,22,23],[24,25,26,27]]
	]]
  ,[ 57,"9","9",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[4,2],[4,3],[5,3],[5,4],[2,4],[2,5],[1,5],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,3],[6,3],[6,2],[5,2],[5,1]
	,[3,5],[3,6],[5,6],[5,5]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],[20,21,22,23]]
	]]
  ,[ 58,":",":",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,3],[5,3],[5,1]
	,[3,4],[3,6],[5,6],[5,4]]
	,[[0,1,2,3],[4,5,6,7]]
	]]
  ,[ 59,";",";",  "", "",[[0,0],[8,8]],[
	[[2,0],[2,1],[3,1],[3,3],[5,3],[5,1],[4,1],[4,0]
	,[3,4],[3,6],[5,6],[5,4]]
	,[[0,1,2,3,4,5,6,7],[8,9,10,11]]
	]]
  ,[ 60,"<","<",  "", "",[[0,0],[8,8]],[
	[[5,1],[5,2],[4,2],[4,3],[3,3],[3,4],[2,4],[2,5],[3,5],[3,6],[4,6],[4,7],[5,7],[5,8],[7,8],[7,7],[6,7],[6,6],[5,6],[5,5],[4,5],[4,4],[5,4],[5,3],[6,3],[6,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[ 61,"=","=",  "", "",[[0,0],[8,8]],[
	[[1,2],[1,3],[7,3],[7,2]
	,[1,5],[1,6],[7,6],[7,5]]
	,[[0,1,2,3],[4,5,6,7]]
	]]
  ,[ 62,">",">",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[2,2],[2,3],[3,3],[3,4],[4,4],[4,5],[3,5],[3,6],[2,6],[2,7],[1,7],[1,8],[3,8],[3,7],[4,7],[4,6],[5,6],[5,5],[6,5],[6,4],[5,4],[5,3],[4,3],[4,2],[3,2],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[ 63,"?","?",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,2],[5,2],[5,1]
	,[3,3],[3,4],[4,4],[4,5],[5,5],[5,6],[3,6],[3,5],[1,5],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,5],[6,5],[6,4],[5,4],[5,3]]
	,[[0,1,2,3],[4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]]
	]]
  ,[ 64,"@","@",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,3],[4,3],[4,5],[5,5],[5,6],[3,6],[3,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]]
	]]
  ,[ 65,"A","A",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,5],[2,5],[2,6],[3,6],[3,7],[5,7],[5,6],[6,6],[6,5],[7,5],[7,1],[5,1],[5,2],[3,2],[3,1]
	,[3,3],[3,5],[5,5],[5,3]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],[16,17,18,19]]
	]]
  ,[ 66,"B","B",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[6,7],[6,6],[7,6],[7,5],[6,5],[6,4],[7,4],[7,2],[6,2],[6,1]
	,[3,5],[3,6],[5,6],[5,5]
	,[3,2],[3,4],[5,4],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11],[12,13,14,15],[16,17,18,19]]
	]]
  ,[ 67,"C","C",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,5],[5,5],[5,6],[3,6],[3,2],[5,2],[5,3],[7,3],[7,2],[6,2],[6,1]]	    ,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[ 68,"D","D",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[5,7],[5,6],[6,6],[6,5],[7,5],[7,3],[6,3],[6,2],[5,2],[5,1]
	,[3,2],[3,6],[4,6],[4,5],[5,5],[5,3],[4,3],[4,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11],[12,13,14,15,16,17,18,19]]
	]]
  ,[ 69,"E","E",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[7,7],[7,6],[3,6],[3,5],[6,5],[6,4],[3,4],[3,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[ 70,"F","F",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[7,7],[7,6],[3,6],[3,5],[6,5],[6,4],[3,4],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9]]
	]]
  ,[ 71,"G","G",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[7,7],[7,6],[3,6],[3,2],[5,2],[5,3],[4,3],[4,4],[7,4],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[ 72,"H","H",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,5],[5,5],[5,7],[7,7],[7,1],[5,1],[5,4],[3,4],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[ 73,"I","I",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[3,2],[3,6],[1,6],[1,7],[7,7],[7,6],[5,6],[5,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[ 74,"J","J",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,3],[3,3],[3,2],[5,2],[5,6],[4,6],[4,7],[7,7],[7,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13]]
	]]
  ,[ 75,"K","K",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,5],[4,5],[4,6],[5,6],[5,7],[7,7],[7,6],[6,6],[6,5],[5,5],[5,3],[6,3],[6,2],[7,2],[7,1],[5,1],[5,2],[4,2],[4,3],[3,3],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]]
	]]
  ,[ 76,"L","L",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5]]
	]]
  ,[ 77,"M","M",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,6],[4,6],[4,5],[5,5],[5,6],[6,6],[6,7],[8,7],[8,1],[6,1],[6,4],[5,4],[5,3],[4,3],[4,4],[3,4],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[ 78,"N","N",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,6],[4,6],[4,5],[5,5],[5,7],[7,7],[7,1],[5,1],[5,2],[4,2],[4,3],[3,3],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[ 79,"O","O",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,2],[6,2],[6,1]
	,[3,2],[3,6],[5,6],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11],[12,13,14,15]]
	]]
  ,[ 80,"P","P",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[6,7],[6,6],[7,6],[7,4],[6,4],[6,3],[3,3],[3,1]
	,[3,4],[3,6],[5,6],[5,4]]
	,[[0,1,2,3,4,5,6,7,8,9],[10,11,12,13]]
	]]
  ,[ 81,"Q","Q",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[2,6],[2,7],[6,7],[6,6],[7,6],[7,3],[6,3],[6,2],[7,2],[7,1],[5,1],[5,2],[4,2],[4,1]
	,[3,3],[3,6],[5,6],[5,3]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17],[18,19,20,21]]
	]]
  ,[ 82,"R","R",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[6,7],[6,6],[7,6],[7,4],[6,4],[6,2],[7,2],[7,1],[5,1],[5,2],[4,2],[4,3],[3,3],[3,1]
	,[3,4],[3,6],[5,6],[5,4]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],[16,17,18,19]]
	]]
  ,[ 83,"S","S",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[5,2],[5,4],[2,4],[2,5],[1,5],[1,6],[2,6],[2,7],[6,7],[6,6],[3,6],[3,5],[6,5],[6,4],[7,4],[7,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[ 84,"T","T",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,6],[1,6],[1,7],[7,7],[7,6],[5,6],[5,1]]
	,[[0,1,2,3,4,5,6,7]]
	]]
  ,[ 85,"U","U",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,2],[5,2],[5,7],[7,7],[7,1]]
	,[[0,1,2,3,4,5,6,7]]
	]]
  ,[ 86,"V","V",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,2],[2,2],[2,3],[1,3],[1,7],[3,7],[3,3],[5,3],[5,7],[7,7],[7,3],[6,3],[6,2],[5,2],[5,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[ 87,"W","W",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,4],[4,4],[4,5],[5,5],[5,4],[6,4],[6,7],[8,7],[8,1],[6,1],[6,2],[5,2],[5,3],[4,3],[4,2],[3,2],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[ 88,"X","X",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,3],[2,3],[2,5],[1,5],[1,7],[3,7],[3,5],[5,5],[5,7],[7,7],[7,5],[6,5],[6,3],[7,3],[7,1],[5,1],[5,3],[3,3],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[ 89,"Y","Y",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,4],[2,4],[2,5],[1,5],[1,7],[3,7],[3,5],[5,5],[5,7],[7,7],[7,5],[6,5],[6,4],[5,4],[5,1],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
	]]
  ,[ 90,"Z","Z",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,3],[2,3],[2,4],[3,4],[3,5],[4,5],[4,6],[1,6],[1,7],[7,7],[7,6],[6,6],[6,5],[5,5],[5,4],[4,4],[4,3],[3,3],[3,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]]
	]]
  ,[ 91,"[","[",  "", "",[[0,0],[8,8]],[ // ] ]
	[[2,1],[2,7],[6,7],[6,6],[4,6],[4,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7]]
	]]
  ,[ 92,"\\","\\","", "",[[0,0],[8,8]],[
	[[6,1],[6,2],[5,2],[5,3],[4,3],[4,4],[3,4],[3,5],[2,5],[2,6],[1,6],[1,7],[3,7],[3,6],[4,6],[4,5],[5,5],[5,4],[6,4],[6,3],[7,3],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]]
	]] 
  ,[ 93,"]","]",  "", "",[[0,0],[8,8]],[  // [ [ 
	[[2,1],[2,2],[4,2],[4,6],[2,6],[2,7],[6,7],[6,1]]
	,[[0,1,2,3,4,5,6,7]]
	]]
  ,[ 94,"^","^",  "", "",[[0,0],[8,8]],[
	[[2,4],[2,5]
		,[3-dx,5],[3,5+dy]
	,[3,6]
		,[4-dx,6],[4,6+dy]
	,[4,7],[5,7]
		,[5,6+dy],[5+dx,6]
	,[6,6]
		,[6,5+dy],[6+dx,5]
	,[7,5],[7,4],[6,4]
		,[6,5-dy],[6-dx,5]
	,[5,5]
		,[5,6-dy],[5-dx,6],[4+dx,6],[4,6-dy]
	,[4,5]
		,[3+dx,5],[3,5-dy]
	,[3,4]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[ 95,"_","_",  "", "",[[0,0],[8,8]],[
	[[0,0],[0,1],[8,1],[8,0]]
	,[[0,1,2,3]]
	]]
  ,[ 96,"`","`",  "", "",[[0,0],[8,8]],[
	[[2,6],[2,7],[3,7]
		,[3,6+dy],[3+dx,6]
	,[4,6]
		,[4,5+dy],[4+dx,5]
	,[5,5],[5,4],[4,4]
		,[4,5-dy],[4-dx,5]
	,[3,5]
		,[3,6-dy],[3-dx,6]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[ 97,"a","a",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,3],[2,3],[2,4],[5,4],[5,5],[2,5],[2,6],[6,6],[6,5],[7,5],[7,1]
	,[3,2],[3,3],[5,3],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13],[14,15,16,17]]
	]]
  ,[ 98,"b","b",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,5],[6,5],[6,4],[7,4],[7,2],[6,2],[6,1]
	,[3,2],[3,4],[5,4],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9],[10,11,12,13]]
	]]
  ,[ 99,"c","c",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,5],[2,5],[2,6],[6,6],[6,5],[3,5],[3,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[100,"d","d",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,4],[2,4],[2,5],[5,5],[5,7],[7,7],[7,1]
	,[3,2],[3,4],[5,4],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9],[10,11,12,13]]
	]]
  ,[101,"e","e",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,5],[2,5],[2,6],[6,6],[6,5],[7,5],[7,3],[3,3],[3,2],[6,2],[6,1]
	,[3,4],[3,5],[5,5],[5,4]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13],[14,15,16,17]]
	]]
  ,[102,"f","f",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,4],[2,4],[2,5],[3,5],[3,6],[4,6],[4,7],[7,7],[7,6],[5,6],[5,5],[7,5],[7,4],[5,4],[5,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[103,"g","g",  "", "",[[0,0],[8,8]],[
	[[1,0],[1,1],[5,1],[5,2],[2,2],[2,3],[1,3],[1,5],[2,5],[2,6],[6,6],[6,5],[7,5],[7,1],[6,1],[6,0]
	,[3,3],[3,5],[5,5],[5,3]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],[16,17,18,19]]
	]]
  ,[104,"h","h",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,5],[6,5],[6,4],[7,4],[7,1],[5,1],[5,4],[3,4],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11]]
	]]
  ,[105,"i","i",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[3,2],[3,4],[2,4],[2,5],[5,5],[5,2],[6,2],[6,1]
	,[3,6],[3,7],[5,7],[5,6]]
	,[[0,1,2,3,4,5,6,7,8,9],[10,11,12,13]]
	]]
  ,[106,"j","j",  "", "",[[0,0],[8,8]],[
	[[2,0],[2,1],[5,1],[5,5],[7,5],[7,1],[6,1],[6,0]
	,[5,6],[5,7],[7,7],[7,6]]
	,[[0,1,2,3,4,5,6,7],[8,9,10,11]]
	]]
  ,[107,"k","k",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,7],[3,7],[3,4],[4,4],[4,5],[6,5],[6,4],[5,4],[5,3],[6,3],[6,2],[7,2],[7,1],[5,1],[5,2],[4,2],[4,3],[3,3],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[108,"l","l",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[3,2],[3,6],[2,6],[2,7],[5,7],[5,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9]]
	]]
  ,[109,"m","m",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,6],[3,6],[3,5],[5,5],[5,6],[7,6],[7,5],[8,5],[8,1],[6,1],[6,3],[5,3],[5,2],[4,2],[4,3],[3,3],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]]
	]]
  ,[110,"n","n",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,6],[6,6],[6,5],[7,5],[7,1],[5,1],[5,5],[3,5],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9]]
	]]
  ,[111,"o","o",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,5],[2,5],[2,6],[6,6],[6,5],[7,5],[7,2],[6,2],[6,1]
	,[3,2],[3,5],[5,5],[5,2]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11],[12,13,14,15]]
	]]
  ,[112,"p","p",  "", "",[[0,0],[8,8]],[
	[[1,0],[1,6],[6,6],[6,5],[7,5],[7,3],[6,3],[6,2],[3,2],[3,0]
	,[3,3],[3,5],[5,5],[5,3]]
	,[[0,1,2,3,4,5,6,7,8,9],[10,11,12,13]]
	]]
  ,[113,"q","q",  "", "",[[0,0],[8,8]],[
	[[5,0],[5,2],[2,2],[2,3],[1,3],[1,5],[2,5],[2,6],[7,6],[7,0]
	,[3,3],[3,5],[5,5],[5,3]]
	,[[0,1,2,3,4,5,6,7,8,9],[10,11,12,13]]
	]]
  ,[114,"r","r",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,6],[6,6],[6,5],[7,5],[7,4],[5,4],[5,5],[3,5],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9]]
	]]
  ,[115,"s","s",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[5,2],[5,3],[2,3],[2,4],[1,4],[1,5],[2,5],[2,6],[7,6],[7,5],[3,5],[3,4],[6,4],[6,3],[7,3],[7,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[116,"t","t",  "", "",[[0,0],[8,8]],[
	[[4,1],[4,2],[3,2],[3,5],[1,5],[1,6],[3,6],[3,7],[5,7],[5,6],[7,6],[7,5],[5,5],[5,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[117,"u","u",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[1,2],[1,6],[3,6],[3,2],[5,2],[5,6],[7,6],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9]]
	]]
  ,[118,"v","v",  "", "",[[0,0],[8,8]],[
	[[3,1],[3,2],[2,2],[2,3],[1,3],[1,6],[3,6],[3,3],[5,3],[5,6],[7,6],[7,3],[6,3],[6,2],[5,2],[5,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]
	]]
  ,[119,"w","w",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,3],[1,3],[1,6],[3,6],[3,4],[4,4],[4,5],[5,5],[5,4],[6,4],[6,6],[8,6],[8,3],[7,3],[7,1],[5,1],[5,2],[4,2],[4,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[120,"x","x",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[2,2],[2,3],[3,3],[3,4],[2,4],[2,5],[1,5],[1,6],[3,6],[3,5],[5,5],[5,6],[7,6],[7,5],[6,5],[6,4],[5,4],[5,3],[6,3],[6,2],[7,2],[7,1],[5,1],[5,2],[3,2],[3,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]
	]]
  ,[121,"y","y",  "", "",[[0,0],[8,8]],[
	[[1,0],[1,1],[4,1],[4,2],[2,2],[2,3],[1,3],[1,6],[3,6],[3,3],[5,3],[5,6],[7,6],[7,2],[6,2],[6,1],[5,1],[5,0]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]]
	]]
  ,[122,"z","z",  "", "",[[0,0],[8,8]],[
	[[1,1],[1,2],[2,2],[2,3],[3,3],[3,4],[4,4],[4,5],[1,5],[1,6],[7,6],[7,5],[6,5],[6,4],[5,4],[5,3],[4,3],[4,2],[7,2],[7,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[123,"{","{",  "", "",[[0,0],[8,8]],[
	[[4,1],[4,2],[3,2],[3,4],[2,4],[2,5],[3,5],[3,7],[4,7],[4,8],[6,8],[6,7],[5,7],[5,5],[4,5],[4,4],[5,4],[5,2],[6,2],[6,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[124,"|","|",  "", "",[[0,0],[8,8]],[
	[[3,0],[3,8],[5,8],[5,0]]
	,[[0,1,2,3]]
	]]
  ,[125,"}","}",  "", "",[[0,0],[8,8]],[
	[[2,1],[2,2],[3,2],[3,4],[4,4],[4,5],[3,5],[3,7],[2,7],[2,8],[4,8],[4,7],[5,7],[5,5],[6,5],[6,4],[5,4],[5,2],[4,2],[4,1]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[126,"~","~",  "", "",[[0,0],[8,8]],[
	[[2,5],[2,6]
		,[3-dx,6],[3,6+dy]
	,[3,7],[5,7],[5,6]
		,[6-dx,6],[6,6+dy]
	,[6,7],[7,7],[7,6]
		,[6+dx,6],[6,6-dy]
	,[6,5],[4,5],[4,6]
		,[3+dx,6],[3,6-dy]
	,[3,5]]
	,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	]]
  ,[127,"^?","",  "DEL","Delete",[[0,0],[8,8]],[]]
  ] ];

// From http://www.brailleauthority.org/sizespacingofbraille/
//
//   Section 3.2 of Specification 800 (Braille Books and Pamphlets) February 2008 reads as follows:
//     Size and Spacing
//     3.2.1	The nominal height of braille dots shall be 0.019 inches [0.48 mm] and shall be uniform within any given transcription.
//     3.2.2	The nominal base diameter of braille dots shall be 0.057 inches [1.44 mm].
//     3.2.3	Cell spacing of dots shall conform to the following:
//     3.2.3.1	The nominal distance from center to center of adjacent dots (horizontally or vertically, but not diagonally)
//              in the same cell shall be 0.092 inches [2.340 mm].
//     3.2.3.2	The nominal distance from center to center of corresponding dots in adjacent cells shall be 0.245 inches [6.2 mm].
//     3.2.4    The nominal line spacing of braille cells from center to center of nearest corresponding dots in adjacent lines shall
//              be 0.400 inches [1.000 cm].
//
// Additional References:
//    http://www.loc.gov/nls/specs/800.pdf
//    http://www.tiresias.org/research/reports/braille_cell.htm
module braille_ascii_spec800(inString,dot_backing=true,cell_backing=false,justify=1,align=-1,dot_h=0.48,dot_d=1.44,dot_spacing=2.340,cell_d2d_spacing=6.2, line_d2d_spacing=10.0, echo_translate=true) {
  // justify:
  //  -1 : left side
  //   0 : center
  //   1 : right side (default)
  // align:
  //  -1 : bottom braille cell edge - shift up (default)
  //   0 : center braille cell
  //   1 : top braille cell edge - shift down
  thisFont=braille_ascii_font(dot_h=dot_h,dot_d=dot_d,dot_spacing=dot_spacing
	,cell_d2d_spacing=cell_d2d_spacing,line_d2d_spacing=line_d2d_spacing);
  x_shift=thisFont[0][0];
  y_shift=thisFont[0][1];
  theseIndicies=search(inString,thisFont[2],1,1);
  for( i=[0:len(theseIndicies)-1]) translate([i*x_shift-(1-justify)*x_shift*len(theseIndicies)/2,-y_shift*(align+1)/2]) {
	dotPattern=thisFont[2][theseIndicies[i]][6];
    if(dot_backing) translate([cell_d2d_spacing/2-dot_spacing/2-dot_d/2,line_d2d_spacing/2-dot_spacing-dot_d/2,-dot_h]) 
	cube(size=[dot_spacing+dot_d,2*dot_spacing+dot_d,dot_h],center=false);
    if(cell_backing) translate([0,0,-dot_h]) 
	cube(size=[x_shift,y_shift,dot_h],center=false);
    if(echo_translate) echo(str(inString[i]," maps to '",thisFont[2][theseIndicies[i]][4],"'"));
    for(dotIndex=dotPattern) {
      translate([cell_d2d_spacing/2-dot_spacing/2+floor((dotIndex-1)/3)*dot_spacing
		, line_d2d_spacing/2-dot_spacing+(2-(dotIndex-1)%3)*dot_spacing])
        scale([dot_d,dot_d,2*dot_h]) sphere($fn=8,r=0.5);
    }
  }
}

// Encoding from http://en.wikipedia.org/wiki/Braille_ASCII
// Dot Pattern:
//  1 4
//  2 5
//  3 6
function braille_ascii_font(dot_h=0.48,dot_d=1.44,dot_spacing=2.340,cell_d2d_spacing=6.2,line_d2d_spacing=10.0) = [
  [cell_d2d_spacing,line_d2d_spacing,0,"bump"],["Decimal Byte","Caret Notation","Character Escape Code","Abbreviation","Name","Bound Box","[bump_list]"]
  ,[
   [  0,"^@","\0","NUL","Null character",[[0,0],[2,3]],[]]
  ,[  1,"^A","",  "SOH","Start of Header",[[0,0],[2,3]],[]]
  ,[  2,"^B","",  "STX","Start of Text",[[0,0],[2,3]],[]]
  ,[  3,"^C","",  "ETX","End of Text",[[0,0],[2,3]],[]]
  ,[  4,"^D","",  "EOT","End of Transmission",[[0,0],[2,3]],[]]
  ,[  5,"^E","",  "ENQ","Enquiry",[[0,0],[2,3]],[]]
  ,[  6,"^F","",  "ACK","Acknowledgment",[[0,0],[2,3]],[]]
  ,[  7,"^G","\a","BEL","Bell",[[0,0],[2,3]],[]]
  ,[  8,"^H","\b","BS", "Backspace",[[0,0],[2,3]],[]]
  ,[  9,"^I","\t","HT", "Horizontal Tab",[[0,0],[2,3]],[]]
  ,[ 10,"^J","\n","LF", "Line Feed",[[0,0],[2,3]],[]]
  ,[ 11,"^K","\v","VT", "Vertical Tab",[[0,0],[2,3]],[]]
  ,[ 12,"^L","\f","FF", "Form feed",[[0,0],[2,3]],[]]
  ,[ 13,"^M","\r","CR", "Carriage return",[[0,0],[2,3]],[]]
  ,[ 14,"^N","",  "SO", "Shift Out",[[0,0],[2,3]],[]]
  ,[ 15,"^O","",  "SI", "Shift In",[[0,0],[2,3]],[]]
  ,[ 16,"^P","",  "DLE","Data Link Escape",[[0,0],[2,3]],[]]
  ,[ 17,"^Q","",  "DC1","Device Control 1",[[0,0],[2,3]],[]]
  ,[ 18,"^R","",  "DC2","Device Control 2",[[0,0],[2,3]],[]]
  ,[ 19,"^S","",  "DC3","Device Control 3",[[0,0],[2,3]],[]]
  ,[ 20,"^T","",  "DC4","Device Control 4",[[0,0],[2,3]],[]]
  ,[ 21,"^U","",  "NAK","Negative Acknowledgement",[[0,0],[2,3]],[]]
  ,[ 22,"^V","",  "SYN","Synchronous Idle",[[0,0],[2,3]],[]]
  ,[ 23,"^W","",  "ETB","End of Transmission Block",[[0,0],[2,3]],[]]
  ,[ 24,"^X","",  "CAN","Cancel",[[0,0],[2,3]],[]]
  ,[ 25,"^Y","",  "EM", "End of Medium",[[0,0],[2,3]],[]]
  ,[ 26,"^Z","",  "SUB","Substitute",[[0,0],[2,3]],[]]
  ,[ 27,"^[","\e","ESC","Escape",[[0,0],[2,3]],[]]
  ,[ 28,"^\\","", "FS", "File Separator",[[0,0],[2,3]],[]]
  ,[ 29,"^]","",  "GS", "Group Separator",[[0,0],[2,3]],[]]
  ,[ 30,"^^","",  "RS", "Record Separator",[[0,0],[2,3]],[]]
  ,[ 31,"^_","",  "US", "Unit Separator",[[0,0],[2,3]],[]]
  ,[ 32," "," ",  "", "Space",[[0,0],[2,3]],[]]
  ,[ 33,"!","!",  "", "the",[[0,0],[2,3]],[ 2,3,4,6 ]]
  ,[ 34,"\"","\"","", "(contraction)",[[0,0],[2,3]],[ 5 ]]
  ,[ 35,"#","#",  "", "(number prefix)",[[0,0],[2,3]],[ 3,4,5,6 ]]
  ,[ 36,"$","$",  "", "ed",[[0,0],[2,3]],[ 1,2,4,6 ]]
  ,[ 37,"%","%",  "", "sh",[[0,0],[2,3]],[ 1,4,6 ]]
  ,[ 38,"&","&",  "", "and",[[0,0],[2,3]],[ 1,2,3,4,6 ]]
  ,[ 39,"'","'",  "", "",[[0,0],[2,3]],[ 3 ]]
  ,[ 40,"(","(",  "", "of",[[0,0],[2,3]],[ 1,2,3,5,6 ]]
  ,[ 41,")",")",  "", "with",[[0,0],[2,3]],[ 2,3,4,5,6 ]]
  ,[ 42,"*","*",  "", "ch",[[0,0],[2,3]],[ 1,6 ]]
  ,[ 43,"+","+",  "", "ing",[[0,0],[2,3]],[ 3,4,6 ]]
  ,[ 44,",",",",  "", "(uppercase prefix)",[[0,0],[2,3]],[ 6 ]]
  ,[ 45,"-","-",  "", "",[[0,0],[2,3]],[ 3,6 ]]
  ,[ 46,".",".",  "", "(italic prefix)",[[0,0],[2,3]],[ 4,6 ]]
  ,[ 47,"/","/",  "", "st",[[0,0],[2,3]],[ 3,4 ]]
  ,[ 48,"0","0",  "", "\"",[[0,0],[2,3]],[ 3,5,6 ]]
  ,[ 49,"1","1",  "", ",",[[0,0],[2,3]],[ 2 ]]
  ,[ 50,"2","2",  "", ";",[[0,0],[2,3]],[ 2,3 ]]
  ,[ 51,"3","3",  "", ":",[[0,0],[2,3]],[ 2,5 ]]
  ,[ 52,"4","4",  "", ".",[[0,0],[2,3]],[ 2,5,6 ]]
  ,[ 53,"5","5",  "", "en",[[0,0],[2,3]],[ 2,6 ]]
  ,[ 54,"6","6",  "", "!",[[0,0],[2,3]],[ 2,3,5 ]]
  ,[ 55,"7","7",  "", "( or )",[[0,0],[2,3]],[ 2,3,5,6 ]]
  ,[ 56,"8","8",  "", "\" or ?",[[0,0],[2,3]],[ 2,3,6 ]]
  ,[ 57,"9","9",  "", "in",[[0,0],[2,3]],[ 3,5 ]]
  ,[ 58,":",":",  "", "wh",[[0,0],[2,3]],[ 1,5,6 ]]
  ,[ 59,";",";",  "", "(letter prefix)",[[0,0],[2,3]],[ 5,6 ]]
  ,[ 60,"<","<",  "", "gh",[[0,0],[2,3]],[ 1,2,6 ]]
  ,[ 61,"=","=",  "", "for",[[0,0],[2,3]],[ 1,2,3,4,5,6 ]]
  ,[ 62,">",">",  "", "ar",[[0,0],[2,3]],[ 3,4,5 ]]
  ,[ 63,"?","?",  "", "th",[[0,0],[2,3]],[ 1,4,5,6 ]]
  ,[ 64,"@","@",  "", "(accent prefix)",[[0,0],[2,3]],[ 4 ]]
  ,[ 65,"A","A",  "", "a",[[0,0],[2,3]],[ 1 ]]
  ,[ 66,"B","B",  "", "b",[[0,0],[2,3]],[ 1,2 ]]
  ,[ 67,"C","C",  "", "c",[[0,0],[2,3]],[ 1,4 ]]
  ,[ 68,"D","D",  "", "d",[[0,0],[2,3]],[ 1,4,5 ]]
  ,[ 69,"E","E",  "", "e",[[0,0],[2,3]],[ 1,5 ]]
  ,[ 70,"F","F",  "", "f",[[0,0],[2,3]],[ 1,2,4 ]]
  ,[ 71,"G","G",  "", "g",[[0,0],[2,3]],[ 1,2,4,5 ]]
  ,[ 72,"H","H",  "", "h",[[0,0],[2,3]],[ 1,2,5 ]]
  ,[ 73,"I","I",  "", "i",[[0,0],[2,3]],[ 2,4 ]]
  ,[ 74,"J","J",  "", "j",[[0,0],[2,3]],[ 2,4,5 ]]
  ,[ 75,"K","K",  "", "k",[[0,0],[2,3]],[ 1,3 ]]
  ,[ 76,"L","L",  "", "l",[[0,0],[2,3]],[ 1,2,3 ]]
  ,[ 77,"M","M",  "", "m",[[0,0],[2,3]],[ 1,3,4 ]]
  ,[ 78,"N","N",  "", "n",[[0,0],[2,3]],[ 1,3,4,5 ]]
  ,[ 79,"O","O",  "", "o",[[0,0],[2,3]],[ 1,3,5 ]]
  ,[ 80,"P","P",  "", "p",[[0,0],[2,3]],[ 1,2,3,4 ]]
  ,[ 81,"Q","Q",  "", "q",[[0,0],[2,3]],[ 1,2,3,4,5 ]]
  ,[ 82,"R","R",  "", "r",[[0,0],[2,3]],[ 1,2,3,5 ]]
  ,[ 83,"S","S",  "", "s",[[0,0],[2,3]],[ 2,3,4 ]]
  ,[ 84,"T","T",  "", "t",[[0,0],[2,3]],[ 2,3,4,5 ]]
  ,[ 85,"U","U",  "", "u",[[0,0],[2,3]],[ 1,3,6 ]]
  ,[ 86,"V","V",  "", "v",[[0,0],[2,3]],[ 1,2,3,6 ]]
  ,[ 87,"W","W",  "", "w",[[0,0],[2,3]],[ 2,4,5,6 ]]
  ,[ 88,"X","X",  "", "x",[[0,0],[2,3]],[ 1,3,4,6 ]]
  ,[ 89,"Y","Y",  "", "y",[[0,0],[2,3]],[ 1,3,4,5,6 ]]
  ,[ 90,"Z","Z",  "", "z",[[0,0],[2,3]],[ 1,3,5,6 ]]
  ,[ 91,"[","[",  "", "ow",[[0,0],[2,3]],[ 2,4,6 ]] // ]]
  ,[ 92,"\\","\\","", "ou",[[0,0],[2,3]],[ 1,2,5,6 ]]  // [[
  ,[ 93,"]","]",  "", "er",[[0,0],[2,3]],[ 1,2,4,5,6 ]] 
  ,[ 94,"^","^",  "", "(contraction)",[[0,0],[2,3]],[ 4,5 ]]
  ,[ 95,"_","_",  "", "(contraction)",[[0,0],[2,3]],[ 4,5,6 ]]
  ,[ 96,"`","`",  "", "",[[0,0],[2,3]],[
	]]
// Repeating upper-case patterns for lower-case letters.
  ,[ 97,"a","a",  "", "a",[[0,0],[2,3]],[ 1 ]]
  ,[ 98,"b","b",  "", "b",[[0,0],[2,3]],[ 1,2 ]]
  ,[ 99,"c","c",  "", "c",[[0,0],[2,3]],[ 1,4 ]]
  ,[100,"d","d",  "", "d",[[0,0],[2,3]],[ 1,4,5 ]]
  ,[101,"e","e",  "", "e",[[0,0],[2,3]],[ 1,5 ]]
  ,[102,"f","f",  "", "f",[[0,0],[2,3]],[ 1,2,4 ]]
  ,[103,"g","g",  "", "g",[[0,0],[2,3]],[ 1,2,4,5 ]]
  ,[104,"h","h",  "", "h",[[0,0],[2,3]],[ 1,2,5 ]]
  ,[105,"i","i",  "", "i",[[0,0],[2,3]],[ 2,4 ]]
  ,[106,"j","j",  "", "j",[[0,0],[2,3]],[ 2,4,5 ]]
  ,[107,"k","k",  "", "k",[[0,0],[2,3]],[ 1,3 ]]
  ,[108,"l","l",  "", "l",[[0,0],[2,3]],[ 1,2,3 ]]
  ,[109,"m","m",  "", "m",[[0,0],[2,3]],[ 1,3,4 ]]
  ,[110,"n","n",  "", "n",[[0,0],[2,3]],[ 1,3,4,5 ]]
  ,[111,"o","o",  "", "o",[[0,0],[2,3]],[ 1,3,5 ]]
  ,[112,"p","p",  "", "p",[[0,0],[2,3]],[ 1,2,3,4 ]]
  ,[113,"q","q",  "", "q",[[0,0],[2,3]],[ 1,2,3,4,5 ]]
  ,[114,"r","r",  "", "r",[[0,0],[2,3]],[ 1,2,3,5 ]]
  ,[115,"s","s",  "", "s",[[0,0],[2,3]],[ 2,3,4 ]]
  ,[116,"t","t",  "", "t",[[0,0],[2,3]],[ 2,3,4,5 ]]
  ,[117,"u","u",  "", "u",[[0,0],[2,3]],[ 1,3,6 ]]
  ,[118,"v","v",  "", "v",[[0,0],[2,3]],[ 1,2,3,6 ]]
  ,[119,"w","w",  "", "w",[[0,0],[2,3]],[ 2,4,5,6 ]]
  ,[120,"x","x",  "", "x",[[0,0],[2,3]],[ 1,3,4,6 ]]
  ,[121,"y","y",  "", "y",[[0,0],[2,3]],[ 1,3,4,5,6 ]]
  ,[122,"z","z",  "", "z",[[0,0],[2,3]],[ 1,3,5,6 ]]
  ,[123,"{","{",  "", "",[[0,0],[2,3]],[
	]]
  ,[124,"|","|",  "", "",[[0,0],[2,3]],[
	]]
  ,[125,"}","}",  "", "",[[0,0],[2,3]],[
	]]
  ,[126,"~","~",  "", "",[[0,0],[2,3]],[
	]]
  ,[127,"^?","",  "DEL","Delete",[[0,0],[2,3]],[]]
  ] ];
