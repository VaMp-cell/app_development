import React, { useState } from 'react';
import { 
  StyleSheet, 
  Text, 
  View, 
  TextInput, 
  TouchableOpacity, 
  ActivityIndicator, 
  Image,
  ScrollView,
  Alert,
  SafeAreaView 
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';

// Pokémon type colors
const typeColors = {
  Normal: '#A8A878', Fire: '#F08030', Water: '#6890F0', Grass: '#78C850',
  Electric: '#F8D030', Ice: '#98D8D8', Fighting: '#C03028', Poison: '#A040A0',
  Ground: '#E0C068', Flying: '#A890F0', Psychic: '#F85888', Bug: '#A8B820',
  Rock: '#B8A038', Ghost: '#705898', Dragon: '#7038F8', Steel: '#B8B8D0',
  Dark: '#705848', Fairy: '#EE99AC',
};

// Type Badge Component
const TypeBadge = ({ type }) => {
  const color = typeColors[type] || '#6B7280';
  return (
    <LinearGradient
      colors={[color, '#ffffff30']}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={styles.typeBadge}
    >
      <Text style={styles.typeText}>{type}</Text>
    </LinearGradient>
  );
};

export default function App() {
  const [searchText, setSearchText] = useState('');
  const [pokemonData, setPokemonData] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  const searchPokemon = async () => {
    if (!searchText.trim()) {
      Alert.alert('Search Required', 'Please enter a Pokémon name or ID.');
      return;
    }

    setIsLoading(true);
    setPokemonData(null);

    const query = searchText.toLowerCase().trim();
    const apiUrl = `https://pokeapi.co/api/v2/pokemon/${query}`;

    try {
      const response = await fetch(apiUrl);
      if (!response.ok) {
        Alert.alert('Not Found', `Pokémon "${searchText}" not found.`);
        return;
      }

      const data = await response.json();
      const extractedData = {
        name: data.name.charAt(0).toUpperCase() + data.name.slice(1),
        id: data.id,
        imageUrl: data.sprites.front_default,
        types: data.types.map(t => ({
          name: t.type.name.charAt(0).toUpperCase() + t.type.name.slice(1),
          slot: t.slot,
        })),
        weight: data.weight / 10,
        height: data.height / 10,
      };

      setPokemonData(extractedData);
    } catch (err) {
      Alert.alert('Network Error', 'Check your internet connection.');
    } finally {
      setIsLoading(false);
    }
  };

  const renderPokemonCard = () => {
    if (!pokemonData) return null;

    const finalImageUrl = pokemonData.imageUrl
      ? { uri: pokemonData.imageUrl }
      : { uri: 'https://upload.wikimedia.org/wikipedia/commons/5/53/Pok%C3%A9_Ball_icon.svg' };

    return (
      <LinearGradient
        colors={['#ffffff', '#dbeafe']}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={styles.card}
      >
        <Text style={styles.cardTitle}>
          {pokemonData.name}
          <Text style={styles.cardSubtitle}> #{String(pokemonData.id).padStart(3, '0')}</Text>
        </Text>

        <Image style={styles.pokemonImage} source={finalImageUrl} resizeMode="contain" />

        <View style={styles.typesContainer}>
          {pokemonData.types.map((type) => (
            <TypeBadge key={type.slot} type={type.name} />
          ))}
        </View>

        <View style={styles.detailsContainer}>
          <View style={styles.detailItem}>
            <Text style={styles.detailLabel}>Height</Text>
            <Text style={styles.detailValue}>{pokemonData.height} m</Text>
          </View>
          <View style={styles.detailItem}>
            <Text style={styles.detailLabel}>Weight</Text>
            <Text style={styles.detailValue}>{pokemonData.weight} kg</Text>
          </View>
        </View>
      </LinearGradient>
    );
  };

  return (
    <LinearGradient
      colors={['#FEE2E2', '#FEF9C3', '#D9F99D']}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={styles.safeArea}
    >
      <SafeAreaView style={{ flex: 1 }}>
        <ScrollView contentContainerStyle={styles.container}>
          <Text style={styles.header}>Pokédex Search</Text>

          {/* Search bar */}
          <View style={styles.searchBarContainer}>
            <TextInput
              style={styles.searchInput}
              placeholder="Enter Pokémon name or ID"
              placeholderTextColor="#9CA3AF"
              value={searchText}
              onChangeText={setSearchText}
              onSubmitEditing={searchPokemon}
            />
            <TouchableOpacity
              style={[styles.searchButton, isLoading && { opacity: 0.7 }]}
              onPress={searchPokemon}
              disabled={isLoading}
            >
              {isLoading ? (
                <ActivityIndicator color="#fff" />
              ) : (
                <Text style={styles.searchButtonText}>Go</Text>
              )}
            </TouchableOpacity>
          </View>

          {renderPokemonCard()}
        </ScrollView>
      </SafeAreaView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
  container: {
    alignItems: 'center',
    padding: 20,
    minHeight: '100%',
  },
  header: {
    fontSize: 34,
    fontWeight: '900',
    color: '#1E3A8A',
    marginBottom: 25,
    textShadowColor: 'rgba(0,0,0,0.1)',
    textShadowOffset: { width: 1, height: 2 },
    textShadowRadius: 4,
  },
  searchBarContainer: {
    flexDirection: 'row',
    width: '100%',
    maxWidth: 420,
    backgroundColor: '#fff',
    borderRadius: 25,
    paddingHorizontal: 15,
    paddingVertical: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.15,
    shadowRadius: 6,
    elevation: 5,
  },
  searchInput: {
    flex: 1,
    height: 45,
    fontSize: 16,
    color: '#111827',
  },
  searchButton: {
    backgroundColor: '#2563EB',
    borderRadius: 20,
    paddingHorizontal: 18,
    justifyContent: 'center',
    alignItems: 'center',
  },
  searchButtonText: {
    color: '#fff',
    fontWeight: '700',
    fontSize: 16,
  },
  card: {
    width: '100%',
    maxWidth: 360,
    borderRadius: 20,
    padding: 20,
    marginTop: 30,
    shadowColor: '#1E40AF',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.25,
    shadowRadius: 12,
    elevation: 10,
    alignItems: 'center',
  },
  cardTitle: {
    fontSize: 26,
    fontWeight: '800',
    color: '#1E293B',
    marginBottom: 5,
  },
  cardSubtitle: {
    fontSize: 18,
    color: '#64748B',
  },
  pokemonImage: {
    width: 180,
    height: 180,
    marginVertical: 10,
  },
  typesContainer: {
    flexDirection: 'row',
    gap: 10,
    marginBottom: 10,
  },
  typeBadge: {
    borderRadius: 25,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderWidth: 1,
    borderColor: '#ffffff40',
  },
  typeText: {
    color: '#fff',
    fontWeight: '700',
    fontSize: 14,
    textTransform: 'uppercase',
  },
  detailsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginTop: 15,
    width: '100%',
  },
  detailItem: {
    alignItems: 'center',
  },
  detailLabel: {
    color: '#6B7280',
    fontSize: 14,
  },
  detailValue: {
    color: '#111827',
    fontSize: 16,
    fontWeight: '700',
  },
});
