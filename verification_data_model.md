1. Overview

This document defines the data structure for storing employment verification records.

Each verification represents a field visit performed by an agent to confirm employment information at a company.

The system must store:

verification details

evidence collected during the visit

agent information

timestamps and status

2. Main Entity: Verification

Each verification task represents one employment verification request handled by a field agent.

Example structure:

{
"verification_id": "VER_1042",
"employee_name": "John Doe",
"company_name": "ABC Logistics",
"company_address": "Tunis, Tunisia",
"manager_name": "Ahmed Ali",
"manager_phone": "+216xxxxxxxx",
"agent_id": "agent_01",
"status": "completed",
"visit_date": "2026-03-05",
"created_at": "2026-03-04T10:00:00Z",
"notes": "Manager confirmed employment"
}
3. Evidence Data

Each verification may contain multiple pieces of evidence.

Evidence includes:

company photos

GPS photo

agent selfie

signed employment certificate

Example structure:

{
"evidence": {
"company_photos": [
"photo_1_url",
"photo_2_url"
],
"signed_certificate": "document_url",
"agent_selfie": "selfie_url"
}
}

Files should be stored in cloud storage, not inside the database.

The database only stores file URLs.

4. GPS Data

Location data helps prove the agent visited the company.

Example:

{
"location": {
"latitude": 36.8065,
"longitude": 10.1815
}
}

Optional fields:

{
"gps_timestamp": "2026-03-05T14:21:00Z"
}
5. Agent Entity

Agents are the people performing the verification.

Example:

{
"agent_id": "agent_01",
"name": "Hisham",
"phone": "+216xxxxxxxx",
"country": "Tunisia",
"active": true
}

Later you could add:

authentication credentials

reliability score

verification history

6. Verification Status

Each verification can have a status.

Possible values:

pending
in_progress
completed
rejected

Example:

{
"status": "completed"
}
7. Storage Structure (Firebase Storage)

Suggested folder structure:

/verifications
/VER_1042
company_photo_1.jpg
company_photo_2.jpg
signed_certificate.jpg
selfie.jpg

The database stores links to these files.

8. Firestore Collection Structure

Example structure:

agents
agent_01
agent_02

verifications
VER_1042
VER_1043

Inside verifications:

verifications
VER_1042
employee_name
company_name
company_address
manager_name
manager_phone
agent_id
status
visit_date
notes
location
evidence
9. Minimal Version (MVP)

For the first version of your app, you only need these fields:

{
"employee_name": "",
"company_name": "",
"company_address": "",
"manager_name": "",
"manager_phone": "",
"notes": "",
"photos": [],
"document": "",
"visit_date": "",
"location": {}
}