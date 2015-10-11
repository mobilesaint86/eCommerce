//
//  installation.js
//  eCommerce
//
//  Created by Albert Chen on 9/13/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

/* 
 * Description: Make sure all installations point to the current user.
 */
Parse.Cloud.beforeSave(Parse.Installation, function(request, response) 
{
	Parse.Cloud.useMasterKey();
  	if (request.user) 
  	{
		request.object.set('user', request.user);
  	} 
  	else 
  	{
  		request.object.unset('user');
  	}

  	response.success();
});
