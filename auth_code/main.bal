import ballerina/http;

configurable string headerValue = ?;

service / on new http:Listener(4000, host = "localhost") {

    // Once authroize request is received, redirect to the asgardeo login page, and submited credentials are authenticated by the asgardeo
    // and redirect back to the redirect_uri with the authorization code
    // This authorization code is used to get the access token via this token endpoint in the client app side (via ajax maybe)
    // This access token is returned to access the scope restricted resource
    isolated resource function get token(string code) returns json|error {

        http:Client asgardeoClient = check new("https://api.asgardeo.io");
        http:Response tokenResp = check asgardeoClient->post("/t/wso2cs/oauth2/token",
                                {
                                    grant_type: "authorization_code",
                                    code: string `${code}`,
                                    redirect_uri: "http://localhost:3000"
                                },
                                headers={"Authorization": string `Basic ${headerValue}`},
                                mediaType = "application/json");
        return tokenResp.getJsonPayload();
    }


    // Use the access token in the header to access the scope restricted resource
    isolated resource function get scope_restricted_resource() {

    }
}