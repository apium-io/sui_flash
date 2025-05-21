**sui\_flash::profile — On-Chain Flash-Card Manager**
*Hackathon Submission | Built on Sui*

---

## 🚀 Project Overview

**SuiFlash** is an on-chain flash-card and study-buddy platform built for rapid prototyping in a hackathon setting. Leveraging Sui’s Move smart-contract framework, SuiFlash lets users:

* **Self-register** on-chain and manage their own profile object
* **Create named collections** of flash cards (decks)
* **Add individual flash cards** (front & back text) into those decks
* Store all user data immutably via Move **dynamic fields** and **tables**

By making every deck and card a first-class Sui object, SuiFlash demonstrates how on-chain study tools can be built with strong ownership guarantees, native transferability, and transparent state evolution.

---

## 🎯 Key Features

1. **User Registration**

   * Single `ProfileManager` singleton tracks which addresses have customized profiles
   * Each new registrant receives a unique `UserProfile` object, embedding their own `UserData`

2. **Dynamic Field Storage**

   * Per-user data (total decks, total cards, deck metadata) lives in a dynamic field on your `UserProfile`
   * Clean separation between on-chain objects and user-scoped tables

3. **Deck Creation**

   * `create_new_collection` lets you name your deck (e.g. “Biology 101”)
   * New `FlashCardCollection` object is minted and transferred to your address

4. **Card Minting**

   * `add_flash_card` creates individual `FlashCard` objects with front/back text
   * Cards are stored in the deck’s internal table, and deck counts auto-increment

5. **Pure Move-Native Logic**

   * All validation, error handling, and state updates happen within Move entry functions
   * No off-chain components needed to run or test basic flows

---

## 🏃‍♀️ Quick Start & CLI Examples

1. **Deploy your package**

   ```bash
   sui client publish
   ```
   ```
