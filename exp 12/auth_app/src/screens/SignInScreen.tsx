import React, { useState, useContext } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';
import { AuthContext } from '../contexts/AuthProvider';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';

const SignInScreen = () => {
  const router = useRouter();
  const { login } = useContext(AuthContext);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  return (
    <View style={styles.container}>
      {/* Header */}
      <LinearGradient colors={['#007AFF', '#00C6FF']} style={styles.header}>
        <Ionicons name="lock-closed-outline" size={26} color="#fff" />
        <Text style={styles.headerTitle}>Sign In</Text>
      </LinearGradient>

      {/* Card */}
      <View style={styles.card}>
        <Text style={styles.title}>Welcome Back 👋</Text>
        <Text style={styles.subtitle}>Sign in to continue</Text>

        <TextInput
          placeholder="Email"
          value={email}
          onChangeText={setEmail}
          style={styles.input}
          keyboardType="email-address"
        />
        <TextInput
          placeholder="Password"
          secureTextEntry
          value={password}
          onChangeText={setPassword}
          style={styles.input}
        />

        <TouchableOpacity style={styles.button} onPress={() => login(email, password)}>
          <Text style={styles.buttonText}>Sign In</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={() => router.push('/signup' as never)}>
          <Text style={styles.link}>Don’t have an account? Sign Up</Text>
        </TouchableOpacity>
      </View>

      {/* Footer */}
      <Text style={styles.footer}>© 2025 Image Viewer App</Text>
    </View>
  );
};

export default SignInScreen;

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f7faff' },
  header: {
    width: '100%',
    paddingTop: 60,
    paddingBottom: 20,
    paddingHorizontal: 25,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  headerTitle: { color: '#fff', fontSize: 22, fontWeight: '700' },
  card: {
    backgroundColor: '#fff',
    borderRadius: 20,
    padding: 25,
    margin: 20,
    marginTop: 40,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 6,
    elevation: 3,
  },
  title: { fontSize: 26, fontWeight: '700', color: '#000', marginBottom: 6 },
  subtitle: { fontSize: 16, color: '#666', marginBottom: 25 },
  input: {
    backgroundColor: '#f8f9fb',
    borderRadius: 10,
    padding: 14,
    marginBottom: 15,
    fontSize: 16,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  button: {
    backgroundColor: '#007AFF',
    borderRadius: 10,
    padding: 15,
    alignItems: 'center',
    marginTop: 10,
  },
  buttonText: { color: '#fff', fontWeight: '600', fontSize: 16 },
  link: {
    textAlign: 'center',
    color: '#007AFF',
    marginTop: 15,
    fontWeight: '500',
  },
  footer: {
    position: 'absolute',
    bottom: 20,
    width: '100%',
    textAlign: 'center',
    color: '#999',
    fontSize: 12,
  },
});
