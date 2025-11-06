Feature: Proximity Check-in
The core logic is: An Attendee can only be marked as "Attended" if both the Attendee and the Host are within 1km of the event's location.

1. The Attendee's Experience (Sending the Request)
Enters the Event Chat: The user, "Alex," has already "Joined" the "Weekend Brunch Club" and is now at the event. He opens the event's chat screen.

Sees the "Check-in" Button: At the bottom of the chat (perhaps next to the "send message" icon), there is a new "Check-in" or "Verify My Attendance" button.

Taps the Button: Alex taps the "Check-in" button.

App Checks Location (Condition 1):

Success: The app instantly gets Alex's GPS coordinates and compares them to the event location ("Beachside Bistro"). He is only 50 meters away (less than 1km).

Failure: If Alex was 2km away (or had GPS turned off), the app would show an error: "You must be within 1km of Beachside Bistro to check in."

Request is Sent: Since Alex is at the location, a special "request" message is sent into the chat, visible to the Host. This could look like a system message:

"👋 Alex has sent a check-in request." [Pending Approval]

2. The Host's Experience (Approving the Request)
Receives the Request: The Host, "Sarah," is also at the restaurant. She sees the "check-in request" from Alex in the chat.

Sees the "Approve" Button: On that chat message, Sarah (and only Sarah, the host) sees an "Approve" button.

Taps the "Approve" Button:

App Checks Location (Condition 2):

Success: The app instantly checks Sarah's (the Host's) GPS. She is also at the bistro (75 meters away). The "1km" condition is met for both users.

Failure: If Sarah was at home (5km away), tapping "Approve" would fail: "You must be within 1km of the event to approve check-ins."

Approval is Confirmed: Because both users passed their geofence check, the approval is successful.

Chat Updates: The original "request" message in the chat updates for everyone to see:

"✅ The host has verified Alex's attendance."

System Records Attendance: In the app's backend, Alex is now officially marked as "Attended."

Why this System is So Effective:
Solves the Fairness Issue: A Host cannot sit at home and collect the pot. They must be at the event to approve attendees.

Dual Verification: It prevents a Host from dishonestly marking an attendee as a "no-show" (like in the manual check-in). The attendee initiates the request, creating a record.

Creates a Public Log: By putting the verification messages in the group chat, all other attendees can see, in real-time, who has been successfully checked in. This transparency builds massive trust.

Low Friction: It's a simple, two-tap process (one for the user, one for the host) that happens right in the chat where they are likely already coordinating.

Key Considerations:
Location Permissions: Your app must ask for and receive Precise Location permissions from both the Host and the Attendee for this to work. You'll need a clear explanation of why you need it (e.g., "We use your location only during the event to verify attendance and ensure fairness for everyone").

GPS Inaccuracy: A 1km radius is quite large and a good, safe buffer for GPS "drift," especially indoors. This is a smart choice.

Alternative Flow: What if the Host wants to initiate? You could also have a "Check-in Attendee" button for the Host in their attendee list. They tap a user's name, the user gets a prompt, and it checks both locations. This is just a different flow, but the geofencing logic is the same.