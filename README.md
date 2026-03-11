# Eventora

> A full-featured event discovery and ticketing app for managing events in real time.

---

## Overview

Eventora is a Flutter app for discovering, creating, and attending events — from local meetups to organized conferences. Users browse events by category and location, purchase or RSVP for tickets, and receive real-time updates from event organizers.

---

## Problem

Event discovery is fragmented across platforms that mix local and global events without useful filtering. Creating an event still requires a website or desktop tool, and ticket management — confirmations, cancellations, guest lists — lacks a mobile-native workflow.

---

## Solution

Eventora centralizes event creation and attendance in one mobile experience. Organizers manage events, track RSVPs, and push announcements directly in-app. Attendees browse by category and location, RSVP or purchase tickets, and get real-time push updates.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Appwrite Auth (email + Google OAuth) |
| Database | Appwrite Database (collections) |
| Storage | Appwrite Storage (event banners, assets) |
| Backend Logic | Appwrite Functions (Node.js runtime) |
| Real-time | Appwrite Realtime (WebSocket subscriptions) |
| Push Notifications | Appwrite Messaging + flutter_local_notifications |
| Maps | google_maps_flutter |
| Payments | mockable payment intent hook (placeholder) |
| State | flutter_bloc |

---

## Features

**Core**
- Browse events by category (Music, Sports, Tech, Food, Arts, Community)
- Search by keyword, date range, and radius from current location
- Event detail page with banner, description, organizer info, and ticket tiers
- RSVP (free) and ticket purchase flow with quantity selector
- QR ticket generation per attendee stored locally and in Appwrite
- Organizer panel: create/edit/cancel events, view guest list, adjust capacity

**Backend & Infrastructure**
- Appwrite Auth with email/password and OAuth2, session tokens refreshed automatically
- Appwrite Database collections: `events`, `users`, `tickets`, `categories` with document-level permission rules
- Appwrite Realtime subscriptions on `events` collection — attendee count updates live without polling
- Appwrite Storage with CDN for event banner images; upload flow validates file type and size at function level
- Appwrite Function runs on POST `/book-ticket`: validates capacity, creates ticket document, and triggers confirmation message
- Appwrite Messaging sends booking confirmation and organizer announcements via push and email
- Appwrite Function cancellation hook: on event cancellation, marks all tickets void and sends refund notification
- Row-level document permissions: only event creator can update/delete event documents

**Discovery & UX**
- Map view showing event pins in a 25km radius with tap-to-preview cards
- Calendar date picker to filter events by day
- Saved/bookmarked events list with offline cached data
- Animated hero transitions between event list and detail
- Countdown timer on event cards within 48 hours of start

**Attendee Flow**
- Ticket wallet: all upcoming tickets with QR code
- Scan mode for organizers to validate QR check-in
- Post-event prompt for review/rating
- Push notification 1 hour before event start

---

## Challenges

- Preventing ticket overbooking under concurrent purchase requests without a dedicated queuing system
- Ensuring Appwrite Realtime WebSocket connections reconnect seamlessly after network interruption
- Generating scannable QR codes locally and syncing validation state with the Appwrite backend

---

## Screenshots

_Discover · Event Detail · Ticket Wallet · Organizer Panel_
