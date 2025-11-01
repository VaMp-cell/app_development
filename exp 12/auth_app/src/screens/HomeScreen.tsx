import React, { useContext } from 'react';
import { View, Text, TouchableOpacity, Image, StyleSheet, Dimensions } from 'react-native';
import Carousel from 'react-native-reanimated-carousel';
import { AuthContext } from '../contexts/AuthProvider';
import { useRouter } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';

const { width: screenWidth } = Dimensions.get('window');

const HomeScreen = () => {
  const { user, logout } = useContext(AuthContext);
  const router = useRouter();

  const images = [
    require('../../assets/images/img1.jpg'),
    require('../../assets/images/img2.jpg'),
    require('../../assets/images/img3.jpg'),
  ];

  return (
    <View style={styles.container}>
      {/* Gradient Header */}
      <LinearGradient colors={['#007AFF', '#00C6FF']} style={styles.header}>
        <TouchableOpacity onPress={() => router.push('/profile' as never)}>
          <Image
            source={{ uri: 'https://img.icons8.com/ios-filled/50/ffffff/user.png' }}
            style={styles.profileIcon}
          />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Home</Text>
        <TouchableOpacity onPress={logout}>
          <Text style={styles.logoutText}>Logout</Text>
        </TouchableOpacity>
      </LinearGradient>

      {/* Welcome Section */}
      <View style={styles.welcomeSection}>
        <Text style={styles.welcome}>Welcome back,</Text>
        <Text style={styles.username}>{user?.displayName || 'User'} 👋</Text>
      </View>

      {/* Carousel */}
      <Text style={styles.sectionTitle}>This is the Home Screen</Text>
      
    </View>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f7faff', alignItems: 'center' },
  header: {
    width: '100%',
    paddingTop: 50,
    paddingHorizontal: 20,
    paddingBottom: 15,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  profileIcon: { width: 30, height: 30, tintColor: '#fff' },
  headerTitle: { color: '#fff', fontSize: 20, fontWeight: '700' },
  logoutText: { color: '#5d0000ff', fontWeight: '600' },
  welcomeSection: { width: '90%', marginVertical: 25 },
  welcome: { fontSize: 18, color: '#444' },
  username: { fontSize: 26, fontWeight: '700', color: '#000' },
  sectionTitle: { fontSize: 18, fontWeight: '600', marginTop: 10, color: '#000' },
  swipeHint: { color: '#555', marginBottom: 10 },
  carouselCard: {
    borderRadius: 16,
    overflow: 'hidden',
    backgroundColor: '#fff',
    shadowColor: '#000',
    shadowOpacity: 0.15,
    shadowRadius: 6,
    elevation: 3,
  },
  carouselImage: { width: '100%', height: 220, borderRadius: 16 },
});
