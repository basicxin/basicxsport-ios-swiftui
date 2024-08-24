//
//  MoreView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import StoreKit
import SwiftUI
struct MoreView: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        GeometryReader { geometryReader in
            ScrollView {
                VStack {
                    Form {
                        Section(header: Text("About App")) {
                            Link(destination: URL(string: URLs.FAQ)!) {
                                OptionsRowView(text: "FAQ")
                            }
                            
                            Link(destination: URL(string: URLs.ABOUT_APP)!) {
                                OptionsRowView(text: "About App")
                            }
                            
                            Link(destination: URL(string: URLs.TERM_AND_CONDITION)!) {
                                OptionsRowView(text: "Terms & Condition")
                            }
                            
                            Link(destination: URL(string: URLs.PRIVACY_POLICY)!) {
                                OptionsRowView(text: "Privacy Policy")
                            }
                            
                            Button(action: {
                                inviteSheet()
                            }, label: { OptionsRowView(text: "Invite Friend") })
                            
                        }
                        
                        Section(header: Text("Profile")) {
                            NavigationLink(destination: ChangePasswordView()) {
                                OptionsRowView(text: "Change Password")
                            }
                            
                            Button(action: {
                                logoutUser()
                            }, label: { OptionsRowView(text: "Logout") })
                            
                        }
                        
                        NavigationLink(destination: DeleteAccountView() )  {
                            OptionsRowView(text: "Delete Account", color: Color.red)
                        }
                        
                        
                    }
                    
                    VStack {
                        Text(Bundle.main.releaseVersionNumberPretty)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        
                        Text("Copyright \(Date().year.string) @StartWith Basicx Pvt. Ltd.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(height: geometryReader.size.height)
            }
        }
    }
    
    func logoutUser() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        settings.loggedIn = false
    }
    
    func inviteSheet() {
        guard let urlShare = URL(string: "https://www.basicxsport.com/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct OptionsRowView: View {
    var text: String = ""
    var color: Color = Color.label
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(color)
        }
        .fullWidth(alignement: .leading)
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView().environmentObject(UserSettings())
    }
}
