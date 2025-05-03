import { onRequest } from "firebase-functions/v2/https";
import axios from "axios";
import * as functions from "firebase-functions";

const clientId = "826c83b9cc66470b98e91492884bab68";
const clientSecret = functions.config().spotify.client_secret;
const redirectUri = "moodflow://spotify-callback";

export const exchangeSpotifyCode = onRequest({
  cors: ["https://moodflow-1390a.firebaseapp.com", "moodflow://spotify-callback", "*"],
  maxInstances: 10,
}, async (req, res) => {
  try {
    const code = req.query.code as string;

    if (!code) {
      res.status(400).json({ error: "Missing Spotify code" });
      return;
    }

    if (!clientSecret) {
      console.error("Spotify client secret is not configured");
      res.status(500).json({ error: "Server configuration error" });
      return;
    }

    console.log("Exchanging code for token...");
    const response = await axios.post(
      "https://accounts.spotify.com/api/token",
      new URLSearchParams({
        grant_type: "authorization_code",
        code: code,
        redirect_uri: redirectUri,
      }).toString(),
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          Authorization:
            "Basic " +
            Buffer.from(`${clientId}:${clientSecret}`).toString("base64"),
        },
      }
    );

    console.log("Token exchange successful");
    res.json({
      access_token: response.data.access_token,
      refresh_token: response.data.refresh_token,
      expires_in: response.data.expires_in,
    });
  } catch (error) {
    console.error("Error exchanging Spotify code:", error);
    if (axios.isAxiosError(error)) {
      res.status(error.response?.status || 500).json({
        error: "Failed to exchange Spotify code",
        details: error.response?.data || error.message,
      });
    } else {
      res.status(500).json({
        error: "Failed to exchange Spotify code",
        details: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
}); 