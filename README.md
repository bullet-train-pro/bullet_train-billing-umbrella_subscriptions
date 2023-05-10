# Child Subscriptions for Bullet Train Billing

## Motivation

Sometimes it's inconvenient for every team to have a unique subscription. For instance an enterprise
may want to pay for multiple teams under a single billing account.

For purposes of illustration we'll discuss the real-world scenario for [Seshy](https://seshy.me). Seshy
is a collaboration and backup tool for musicians. Think of it like GitHub for music.

One user persona for Seshy is that of a musician who works on music both as a solo artist and with a band
(or more than one band).

BulletTrain already facilitates a great data model for the collaboration side. In Seshy every user gets a
"Personal" team for their solo projects, or for brand new tunes that are in rough-draft stage and that
aren't ready to share with collaborators yet.

![your_song](https://user-images.githubusercontent.com/58702/236494773-df1b9285-11e5-45c3-8dfc-1b8149d97955.png)

When you want to share a song with a collaborator you can create a team, invite someone to join the team,
and then share the project with that team. This is a customization/extension of the normal BT object model
where I've introduced a `TeamProject` model that connects a `Team` to a `Project`.

Each `Project` also `belongs_to` one `Team`, and users on that team with the "Project Admin" role can do a
few more things to that project than everyone else (rename, delete, transfer to another team, etc...).

![collaborate](https://user-images.githubusercontent.com/58702/236495741-2ccdbb6e-4435-4f1e-8fc3-630e2fab1018.png)

Out of the box Bullet Train Billing supports a subscription model that will allow a user to purchase a subscription for
one `Team`. For instance a Seshy user might subscribe to the "Solo Artist" tier, which will get them a 50
GB pool of storage, and will allow them to have teams of up to 8 people. (Free tier users get 1 GB of storage
and teams are limited to 3.)

![solo](https://user-images.githubusercontent.com/58702/236496148-8b6b4587-95aa-4b15-940a-c978805d4e5c.png)

In the case where a user has a band as well as their solo stuff Child Subscriptions allows them to "extend"
their solo subscription to also cover their band.

![solo_w_side](https://user-images.githubusercontent.com/58702/236496786-8aea4d96-dc97-418f-8361-1b2bacb18bec.png)

For Seshy I'd like this subscription extension to work differently for the project storage pool than it does
for the membership limit. Specifically I'd like for the storage pool to apply _across_ all teams covered by
the subscription (as shown in the image above). But I'd like for the membership limit to be applied to _each_
team individually. I think that the membership thing should kind of Just Work if we make it so that the usage
gem can somehow "see" a subscription that's been extended to a different team. I think the "cross-team sum"
for the project quota would be a new type of limit in BulletTrain. Or it might just be a Seshy customization
and not part of the official BT implementation.

## User Experience

For Seshy I'm thinking that there will be a "Billing Administrator" role, and that one permission granted to that role will be the abilities to:
  * offer a subscription extension to other teams to which you belong
  * accept a subscription extension from another team, even if you don't belong to the team extending the subscription
  * request a subscription extension from another team to which you belong
  * approve an extension request from another team, even if you don't belong to that team
  
If a user is a Billing Admin for both the source team and the destination team then it would be nice for it to be an all-in-one process of just creating the extension directly instead of it being a two part process of offer/request => approve.

I think that the current billing dashboard could add a link on the current subscription that says "extend subscription" that takes you to a screen that lets you start the process of extending it, and that shows the list of teams currently covered by the subscription.

## Object Model

Currently a `Billing::Subscription` `belongs_to` a single `Team` and the usage gem uses that relationship to find and enforce limits.

To extend a `Subscription` to additional `Teams` I think we'll need a new join model. Something like:

```ruby
class Billing::TeamSubscription
  belongs_to :team

  belongs_to :billing_subscription

  # Alternatively we might want to keep a link to the team that is
  # extending the subscription and then traverse that relationship
  # to find the subscription that applies for this team.
  belongs_to :paying_team
  has_one :billing_subscription, through: :paying_team
end
```

A `Subscription` would still need to `belong_to` a single `Team` for purposes of determining which users are allowed to update the `Subscription` itself.

To facilitate the offer/request scenario we may want an additional model that functions similar to how the `Invitation` model works for `Memberships`.

```ruby
class Billing::TeamSubscriptionInvitation
  belongs_to :source_team # The team that is extending the invitation
  belongs_to :destination_team # The team that is receiving the extension
end
```

It's possible we may need an additional model to distinguish between an extension "request" and an extension "offer". In which case we may want to go with something like `Billing::TeamSubscriptionExtensionRequest` and `Billing::TeamSubscriptionExtensionOffer`.

## Role implementation

I think the existing enforcement mechanisms in the usage gem should get us most of the way there, and would allow for some flexibility in how people use this feature.

```yml
# config/models/roles.yml

team_admin:
  models:
    Billing::TeamSubscriptionExtensionRequest: create

billing_admin:
  models:
    Billing::TeamSubscription: manage
    Billing::TeamSubscriptionInvitation: manage
    Billing::TeamSubscriptionExtensionRequest: manage
```
