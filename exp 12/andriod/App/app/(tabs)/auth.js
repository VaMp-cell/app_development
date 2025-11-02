// app/auth.js
import React, { useState, useRef } from "react";
import { View, Alert, TextInput as RNTextInput } from "react-native";
import { Button, Text, TextInput } from "react-native-paper";
import { FirebaseRecaptchaVerifierModal } from "expo-firebase-recaptcha";
import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signInWithPhoneNumber,
} from "firebase/auth";
import { auth } from "../../fire"; // adjust path if needed
import { useRouter } from "expo-router";
import { firebaseConfig } from "../../fire"; // make sure to export it from fire.js

export default function AuthScreen() {
  const router = useRouter();

  // States
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [phone, setPhone] = useState("");
  const [otp, setOtp] = useState("");
  const [verificationId, setVerificationId] = useState(null);
  const [isLogin, setIsLogin] = useState(false);
  const recaptchaVerifier = useRef(null);

  // ✅ Email/Password Authentication
  const handleEmailAuth = async () => {
    if (!email || !password) {
      Alert.alert("Error", "Please enter email and password");
      return;
    }
    try {
      if (isLogin) {
        await signInWithEmailAndPassword(auth, email, password);
        Alert.alert("Success ✅", "Logged in successfully!");
      } else {
        await createUserWithEmailAndPassword(auth, email, password);
        Alert.alert("Success 🎉", "Account created successfully!");
      }

      // ✅ Navigate to form screen after success
      router.replace("/form");
    } catch (error) {
      Alert.alert("Error", error.message);
    }
  };

  // ✅ Send OTP
  const sendOTP = async () => {
    if (!phone) {
      Alert.alert("Error", "Please enter a valid phone number with +91 prefix");
      return;
    }

    try {
      const confirmation = await signInWithPhoneNumber(
        auth,
        phone,
        recaptchaVerifier.current
      );
      setVerificationId(confirmation.verificationId);
      Alert.alert("OTP Sent 📱", "Check your phone for the verification code");
    } catch (error) {
      console.error(error);
      Alert.alert("Error", error.message);
    }
  };

  // ✅ Verify OTP
  const verifyOTP = async () => {
    if (!verificationId || !otp) {
      Alert.alert("Error", "Please enter the OTP");
      return;
    }

    try {
      const credential = await signInWithPhoneNumber(auth, phone, recaptchaVerifier.current);
      await credential.confirm(otp);
      Alert.alert("Success ✅", "Phone number verified!");
      router.replace("/form");
    } catch (error) {
      Alert.alert("Error", error.message);
    }
  };

  return (
    <View
      style={{
        flex: 1,
        padding: 20,
        backgroundColor: "#fff",
        justifyContent: "center",
      }}
    >
      {/* 🔹 Recaptcha Modal */}
      <FirebaseRecaptchaVerifierModal
        ref={recaptchaVerifier}
        firebaseConfig={firebaseConfig}
      />

      <Text
        style={{
          fontSize: 24,
          fontWeight: "bold",
          textAlign: "center",
          marginBottom: 20,
        }}
      >
        Firebase Authentication
      </Text>

      {/* 🔹 Email/Password Section */}
      <TextInput
        label="Email"
        value={email}
        onChangeText={setEmail}
        mode="outlined"
        keyboardType="email-address"
        style={{ marginBottom: 10 }}
      />
      <RNTextInput
        placeholder="Password"
        secureTextEntry
        value={password}
        onChangeText={setPassword}
        style={{
          borderWidth: 1,
          borderColor: "#aaa",
          borderRadius: 8,
          marginBottom: 10,
          padding: 10,
        }}
      />
      <Button
        mode="contained"
        onPress={handleEmailAuth}
        style={{ marginBottom: 10, backgroundColor: "green" }}
      >
        {isLogin ? "Login" : "Register"}
      </Button>

      <Button mode="text" onPress={() => setIsLogin(!isLogin)}>
        {isLogin ? "Don't have an account? Register" : "Already have an account? Login"}
      </Button>

      {/* 🔹 Phone Authentication */}
      <Text style={{ marginTop: 20, fontWeight: "bold" }}>Phone Authentication</Text>
      <RNTextInput
        placeholder="+91XXXXXXXXXX"
        value={phone}
        onChangeText={setPhone}
        keyboardType="phone-pad"
        style={{
          borderWidth: 1,
          borderColor: "#aaa",
          borderRadius: 8,
          padding: 10,
          marginVertical: 10,
        }}
      />
      <Button
        mode="contained"
        onPress={sendOTP}
        style={{ backgroundColor: "purple", marginBottom: 10 }}
      >
        Send OTP
      </Button>

      {verificationId && (
        <>
          <RNTextInput
            placeholder="Enter OTP"
            value={otp}
            onChangeText={setOtp}
            keyboardType="number-pad"
            style={{
              borderWidth: 1,
              borderColor: "#aaa",
              borderRadius: 8,
              padding: 10,
              marginBottom: 10,
            }}
          />
          <Button mode="contained" onPress={verifyOTP} style={{ backgroundColor: "blue" }}>
            Verify OTP
          </Button>
        </>
      )}
    </View>
  );
}
