//
//  message_employees.js
//  eCommerce
//
//  Created by Albert Chen on 9/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

var constants = require('cloud/constants.js');


/*
 * Get list of employees for a MessageEmployees page
 * (For now find users without role value of 'Buyer')
 * 
 * Expected Input:
 *			request.params.skip: 	Number of objects to skip
 *
 * Expected Output: 
 *			employees: 				List of employees
 */
Parse.Cloud.define("getEmployeesInMessageEmployeesPageWithFilterParams", function(request, response)
{
	Parse.Cloud.useMasterKey();

	var config = Parse.Config.current();

	Parse.Promise.as().then(function()
	{
		return Parse.Config.get().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(result)
	{
		if (result)
		{
			config = result;
		}

		var query = new Parse.Query(constants.kFMUserClassKey);

		// Set up query
		query.notEqualTo(constants.kFMUserRoleKey, constants.kFMUserRoleBuyer);
		query.notEqualTo(constants.kPFObjectObjectIDKey, request.user.id);

		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerMessageEmployees));
		
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(employees)
	{
		if (!employees) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(employees);
	});
});