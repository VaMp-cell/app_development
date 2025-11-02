import React, { useContext } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { AuthContext } from '../contexts/AuthProvider';
import { LinearGradient } from 'expo-linear-gradient';

const ProfileScreen = () => {
  const { user, logout } = useContext(AuthContext);
  const router = useRouter();

  return (
    <View style={styles.container}>
      {/* Header */}
      <LinearGradient colors={['#007AFF', '#00C6FF']} style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Ionicons name="arrow-back" size={26} color="#fff" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Profile</Text>
      </LinearGradient>

      {/* Profile Card */}
      <View style={styles.card}>
        <Ionicons name="person-circle" size={90} color="#007AFF" style={{ alignSelf: 'center' }} />
        <Text style={styles.name}>{user?.displayName || 'Anonymous User'}</Text>
        <Text style={styles.email}>{user?.email}</Text>

        <TouchableOpacity style={styles.logoutBtn} onPress={logout}>
          <Ionicons name="log-out-outline" size={20} color="#fff" />
          <Text style={styles.logoutText}>Logout</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

export default ProfileScreen;

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#00102cff' },
  header: {
    width: '100%',
    paddingTop: 50,
    paddingBottom: 15,
    paddingHorizontal: 20,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#007AFF',
  },
  headerTitle: { color: '#fff', fontSize: 20, fontWeight: '700', marginLeft: 10 },
  card: {
    backgroundColor: '#19005dff',
    padding: 30,
    marginHorizontal: 20,
    marginTop: 100,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 6,
    elevation: 4,
  },
  name: { fontSize: 22, fontWeight: '700', marginTop: 10, color: '#fff' },
  email: { fontSize: 16, color: '#666', marginVertical: 8, color: '#fff' },
  logoutBtn: {
    backgroundColor: '#FF3B30',
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 12,
    borderRadius: 8,
    marginTop: 20,
  },
  logoutText: { color: '#fff', fontWeight: '600', marginLeft: 8 },
});
