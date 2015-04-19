//
//  GitHubExampleJson.swift
//  Genome
//
//  Created by Logan Wright on 4/19/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

public let GITHUB_EVENT_ID = 1
public let GITHUB_EVENT_URL = "https://api.github.com/repos/octocat/Hello-World/issues/events/1"
public let GITHUB_EVENT_DESCRIPTION = "closed"
public let GITHUB_EVENT_COMMIT_ID = "6dcb09b5b57875f334f61aebed695e2e4193db5e"
public let GITHUB_EVENT_CREATED_AT_DATE_STRING = "2011-04-14T16:00:49Z"

public let GITHUB_USER_LOGIN = "octocat"
public let GITHUB_USER_ID = 15
public let GITHUB_USER_API_URL = "https://api.github.com/users/octocat"
public let GITHUB_USER_ADMIN = false
public let GITHUB_USER_TYPE = "User"
public let GITHUB_EVENT_EXAMPLE_JSON: [String : AnyObject] = [
    "id" : GITHUB_EVENT_ID,
    "url" : GITHUB_EVENT_URL,
    "actor" : [
        "login" : GITHUB_USER_LOGIN,
        "id" : GITHUB_USER_ID,
        "url": GITHUB_USER_API_URL,
        "type": GITHUB_USER_TYPE,
        "site_admin": GITHUB_USER_ADMIN
    ],
    "event" : GITHUB_EVENT_DESCRIPTION,
    "commit_id" : GITHUB_EVENT_COMMIT_ID,
    "created_at" : GITHUB_EVENT_CREATED_AT_DATE_STRING
]