Create and Assume Roles in AWS
Introduction
AWS Identity and Access Management (IAM) is a service that allows AWS customers to manage user access and permissions for the accounts and available APIs/services within AWS. IAM can manage users, security credentials (such as API access keys), and allow users to access AWS resources.

In this lab, we discover how security policies affect IAM users and groups, and we go further by implementing our own policies while also learning what a role is, how to create a role, and how to assume a role as a different user. An IAM role is similar to an IAM user, in that it is an AWS identity with permission policies that determine what the identity can and cannot do in AWS. However, instead of being uniquely associated with one person, a role is intended to be assumable by anyone who needs it. Also, a role does not have standard long-term credentials such as a password or access keys associated with it. Instead, when you assume a role, it provides you with temporary security credentials for your role session.

By the end of this lab, you will understand IAM policies and roles, and how assuming roles can assist in restricting users to specific AWS resources.

AWS Documentation: IAM roles.

Solution
Log in to the AWS Management Console using the credentials provided on the lab instructions page. Make sure you're in the N. Virginia (us-east-1) region throughout the lab.

Create the Correct S3 Restricted Policies and Roles
Create the S3RestrictedPolicy
Once you are logged in to the AWS Management Console, navigate to IAM.
From the left-side menu, click Policies.
Click Create Policy.
In Service, click Choose a service.
Type and select S3.
In Actions, select All S3 actions.
Click the arrow next to Resources, and select Any or Any in this account for all resources other than bucket.
Open a new browser tab, and navigate to S3.
Under Buckets, copy the bucket name containing appconfigprod1.
Return to IAM.
In Resources, under bucket, click Add ARN.
Paste in the Bucket name you just copied, and click Add.
Return to S3 and repeat the process with the bucket name containing appconfigprod2.
In IAM, once both buckets are added, click Next: Tags.
Click Next: Review.
For Name, enter "S3RestrictedPolicy", and click Create policy.
Create the S3RestrictedRole
From the IAM dashboard menu, select Roles.
Click Create role.
Under Trusted entity type, select AWS account.
Under the An AWS account section that pops up, make sure This account is selected.
Copy the account number next to This account. You will need this later in the lab.
Click Next.
In the search field, enter "S3" and select S3RestrictedPolicy.
Click Next.
In Role name, enter "S3RestrictedRole". You should see in the JSON block that the trusted entity is your account number. This means that anything that is in this account can assume this role.
Click Create role.
Revoke the S3 Administrator Access Policy to the dev1 User
AWS now auto logs out when logging in as another user (even if in a new Incognito/Private Window). As a work around, you can right-click the lab's blue "Open Link in Incognito/Private Window` button and copy the link into a different browser. You'll then be able to be logged into the other account using the lab provided credentials.
Use the following credentials to log in:
Account ID: The same account ID you previously copied
User: dev1
Password: 3Kk6!AY36^5h1rolJYb@C
Navigate to S3 to see what this user has access to.
Select one of the customerdata buckets and open it in a new tab. You should see that there are no objects, but you do have access to it.
Back in S3, select one of the appconfig buckets, and open it in a new tab. You should see the same access as the customerdata bucket.
Go back to the original IAM browser window that you had open.
From the left-side menu, select User groups.
Select the developergroup.
Select Permissions.
Select the AmazonS3FullAccess policy, and click Remove.
Click Delete.
Go back to the other incognito windows for the dev1 user.
Refresh both windows for the customerdata and appconfig buckets. Note that you will now see an error indicating the user has insufficient permissions to list objects.
Attach the S3RestrictedPolicy to the dev1 User
Go back to the original IAM browser window.
On the left-side menu, select Users.
Select the dev1 user.
Under Permissions, click Add permissions.
Select Attach existing policies directly.
In the search bar, type "S3" and select S3RestrictedPolicy.
Click Next: Review.
Click Add permissions.
Click the arrow next to the policy, and select {} JSON to display and review the policy's contents.
To verify the configuration, return to the dev1 browser and attempt to access the appconfig and customerdata buckets. You should now have access to appconfig buckets, while customerdata buckets are still denied.
Configure IAM So the dev3 User Can Assume the Role
Create the AssumeS3Policy IAM Policy
Open a new incognito browser window using the same account ID as before. Log in as the dev3 user using the following credentials:
User: dev3
Password: 3Kk6!AY36^5h1rolJYb@C
Navigate to S3. Note that dev3and verify the user's current access.
Go back to the original IAM browser window.
From the left-side menu, select Policies.
Click Create policy.
In Service, click Choose a service.
Type and select STS.
In Actions under Access level, click the arrow next to Write to expand its options, and select AssumeRole.
In Resources under role, click Add ARN.
In the Add ARN(s) pop-up window, set Role name with path to "S3RestrictedRole" and click Add.
Click Next: Tags.
Click Next: Review.
For Name, enter "AssumeS3Policy", and click Create policy.
Attach the AssumeS3Policy to the dev3 User
Select the new policy.
Select the Policy usage tab, and click Attach.
Select dev3, and click Attach policy.
Assume the S3RestrictedRole as the dev3 User
Go back to the other browser window where you are logged in as dev3 in S3.
Notice that the dev3 user still doesn't have bucket access because the role has not yet been assumed.
To assume the role, click the user dropdown on the top menu, and copy your account ID in your clipboard.
Click Switch Roles.
In the new window, click Switch Role.
Set the following values:
Account: The account ID you just copied
Role: S3RestrictedRole
Display Name: S3RestrictedRole
Click Switch Role.
To verify the role has been assumed, attempt to access the appconfig and customer data buckets. You should now have access to appconfig buckets, while customer data buckets are still denied.
Conclusion
Congratulations — you've completed this hands-on lab!