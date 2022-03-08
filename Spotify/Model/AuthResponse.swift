//
//  AuthResponse.swift
//  Spotify
//
//  Created by THANSEEF on 08/03/22.
//

import Foundation

struct AuthResponse : Codable {
    let access_token : String
    let expires_in : Int
    let refresh_token : String? //optional.
    let scope : String
    let token_type : String
}



//success {
//    "access_token" = "BQD9h-UJDI8bMgTMrAL8qfdvtINDynmLTrDnrwrAGqWmVNfLiyvQpvHJpeOBbJ7IsBEKNjIFozn7e2mSDyEasfVWaPbhNiYJlgZ31GuZmznbI3cLnEhdNx6C0t8D7tZfaccfYeaeu0geMF1wWGiI3cjxztg3_rc3fv3sZSSBOPDv6qa8Upk";
//    "expires_in" = 3600;
//    "refresh_token" = "AQAwVEogQemtmItdCL74-D5LlOoD_qTkJO2kddofF1S4FE2R2uiQotTVwv61C8aa_GbeGsZJBMf3nS4OYhK0Izrj8DLol1YweQDGMP50TKLuAAguyLsn4LFGkmc_pKrTUso";
//    scope = "user-read-private";
//    "token_type" = Bearer;
//}
