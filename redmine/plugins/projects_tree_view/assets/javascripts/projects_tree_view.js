/* Function to allow the projects to show up as a tree */

function showHide(EL,PM) 
{
	var els = document.getElementsByTagName('tr');
	var elsLen = els.length;
	var pattern = new RegExp("(^|\\s)"+EL+"(\\s|$)");
	var cpattern = new RegExp("span");
	var expand = new RegExp("open");
	var collapse = new RegExp("closed");
	var spanid = PM;
	var classid = new RegExp("junk");
	for (i = 0; i < elsLen; i++)
	{
		if(cpattern.test(els[i].id))
		{
			var tmpspanid = spanid;
			var tmpclassid = classid;
			spanid = els[i].id;
			classid = spanid;
			classid = classid.match(/(\w+)span/)[1];
			classid = new RegExp(classid);
			if(tmpclassid.test(els[i].className) && (tmpspanid.toString() != PM.toString()))
			{
				if(collapse.test(document.getElementById(tmpspanid).className))
				{
					spanid = tmpspanid;
					classid = tmpclassid;
				}			
			}
		}
		
		if ( pattern.test(els[i].className) ) {

		  var cnames = els[i].className;
		  cnames = cnames.replace(/hide/g,'');
		  
		  if (expand.test(document.getElementById(PM).className))
		  {
				cnames += ' hide';
				
		  }
		  else
		  {		
				if((spanid.toString() != PM.toString()) &&
				  (classid.test(els[i].className)))
				{
					  if(collapse.test(document.getElementById(spanid).className))
					  {
						  cnames += ' hide';		 
					  }
				}
		  }
		  
		  els[i].className = cnames;
		  
		}
	}
	if (collapse.test(document.getElementById(PM).className))
	{
		var cnames = document.getElementById(PM).className;
		cnames = cnames.replace(/closed/,'open');
		document.getElementById(PM).className = cnames;
	}
	else
	{
		var cnames = document.getElementById(PM).className;
		cnames = cnames.replace(/open/,'closed');
		document.getElementById(PM).className = cnames;
	}
}

