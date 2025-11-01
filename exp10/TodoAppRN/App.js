import React, { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  FlatList,
  StyleSheet,
  SafeAreaView,
  ActivityIndicator,
  StatusBar,
} from 'react-native';
import firebase from 'firebase/compat/app';
import 'firebase/compat/auth';
import 'firebase/compat/firestore';

// 🔥 Firebase Config
const firebaseConfig = {
  apiKey: "AIzaSyAgXaKatWVtPAk2oHVo9jd4hv8ZUFZZCtQ",
  authDomain: "todolistrn-e878f.firebaseapp.com",
  projectId: "todolistrn-e878f",
  storageBucket: "todolistrn-e878f.firebasestorage.app",
  messagingSenderId: "599063415703",
  appId: "1:599063415703:web:fe3864c19e63239ab0d2d2"
};

// --- Initialize Firebase only once ---
let isFirebaseInitialized = false;
let app, firestore, auth;

// --- Custom Hook for Firebase setup ---
const useFirebase = () => {
  const [userId, setUserId] = useState(null);
  const [isAuthReady, setIsAuthReady] = useState(false);
  const [db, setDb] = useState(null);

  useEffect(() => {
    if (!isFirebaseInitialized && firebaseConfig.projectId && firebaseConfig.apiKey) {
      try {
        if (!firebase.apps.length) {
          app = firebase.initializeApp(firebaseConfig);
        } else {
          app = firebase.app();
        }
        firestore = app.firestore();
        auth = app.auth();
        setDb(firestore);
        isFirebaseInitialized = true;
        console.log("✅ Firebase initialized");
      } catch (e) {
        console.error("❌ Firebase Init Error:", e);
      }
    }

    if (auth) {
      const unsubscribe = auth.onAuthStateChanged(async (user) => {
        if (user) setUserId(user.uid);
        else {
          try {
            const userCredential = await auth.signInAnonymously();
            setUserId(userCredential.user.uid);
          } catch {
            setUserId(crypto.randomUUID());
          }
        }
        setIsAuthReady(true);
      });
      return () => unsubscribe();
    }
  }, []);

  return { db, userId, isAuthReady };
};

// --- Main App Component ---
const App = () => {
  const { db, userId, isAuthReady } = useFirebase();
  const [taskInput, setTaskInput] = useState('');
  const [tasks, setTasks] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  const tasksCollectionPath = `tasks`;

  // 🔄 Real-time Tasks Fetch
  useEffect(() => {
    if (!db || !isAuthReady) return;
    const unsubscribe = db
      .collection(tasksCollectionPath)
      .orderBy('createdAt', 'desc')
      .onSnapshot(snapshot => {
        const fetched = [];
        snapshot.forEach(doc => fetched.push({ id: doc.id, ...doc.data() }));
        setTasks(fetched);
        setIsLoading(false);
      });
    return () => unsubscribe();
  }, [db, isAuthReady]);

  // ➕ Add Task
  const addTask = useCallback(async () => {
    if (!db || !taskInput.trim()) return;
    await db.collection(tasksCollectionPath).add({
      title: taskInput.trim(),
      completed: false,
      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
      createdBy: userId,
    });
    setTaskInput('');
  }, [db, taskInput, userId]);

  // ✅ Toggle Task
  const toggleTask = async (taskId, current) => {
    if (!db) return;
    await db.collection(tasksCollectionPath).doc(taskId).update({ completed: !current });
  };

  // ❌ Delete Task
  const deleteTask = async (taskId) => {
    if (!db) return;
    await db.collection(tasksCollectionPath).doc(taskId).delete();
  };

  const renderTask = ({ item }) => (
    <View style={[styles.taskItem, item.completed && styles.taskItemDone]}>
      <TouchableOpacity onPress={() => toggleTask(item.id, item.completed)} style={styles.checkbox}>
        <Text style={[styles.checkboxIcon, item.completed && styles.checkedIcon]}>
          {item.completed ? '✓' : ''}
        </Text>
      </TouchableOpacity>
      <Text style={[styles.taskText, item.completed && styles.taskCompleted]}>
        {item.title}
      </Text>
      <TouchableOpacity onPress={() => deleteTask(item.id)} style={styles.deleteButton}>
        <Text style={styles.deleteText}>×</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#121212" />
      <Text style={styles.header}>🖤 Dark Tasks</Text>

      <View style={styles.inputContainer}>
        <TextInput
          style={styles.textInput}
          placeholder="Add a new task..."
          placeholderTextColor="#777"
          value={taskInput}
          onChangeText={setTaskInput}
          onSubmitEditing={addTask}
        />
        <TouchableOpacity
          style={[styles.addButton, !taskInput.trim() && styles.addButtonDisabled]}
          onPress={addTask}
          disabled={!taskInput.trim()}
        >
          <Text style={styles.addButtonText}>+</Text>
        </TouchableOpacity>
      </View>

      <Text style={styles.listTitle}>Your Tasks</Text>

      {isLoading ? (
        <ActivityIndicator size="large" color="#0ff" style={{ marginTop: 40 }} />
      ) : (
        <FlatList
          data={tasks}
          renderItem={renderTask}
          keyExtractor={item => item.id}
          ListEmptyComponent={<Text style={styles.emptyText}>No tasks yet ✨</Text>}
          contentContainerStyle={{ paddingBottom: 40 }}
        />
      )}
    </SafeAreaView>
  );
};

// --- Dark Mode Styles ---
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f0f0f',
    paddingHorizontal: 20,
    paddingTop: 30,
  },
  header: {
    fontSize: 30,
    fontWeight: '800',
    color: '#00E5FF',
    textAlign: 'center',
    marginBottom: 25,
    letterSpacing: 1,
  },
  inputContainer: {
    flexDirection: 'row',
    backgroundColor: '#1f1f1f',
    borderRadius: 14,
    paddingHorizontal: 10,
    alignItems: 'center',
    shadowColor: '#00E5FF',
    shadowOpacity: 0.3,
    shadowRadius: 5,
    elevation: 4,
    marginBottom: 25,
  },
  textInput: {
    flex: 1,
    color: '#fff',
    fontSize: 16,
    height: 50,
    paddingHorizontal: 10,
  },
  addButton: {
    width: 50,
    height: 50,
    borderRadius: 12,
    backgroundColor: '#00E5FF',
    justifyContent: 'center',
    alignItems: 'center',
  },
  addButtonDisabled: {
    backgroundColor: '#444',
  },
  addButtonText: {
    fontSize: 28,
    color: '#0f0f0f',
    fontWeight: 'bold',
  },
  listTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#aaa',
    marginBottom: 10,
  },
  taskItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#1a1a1a',
    borderRadius: 12,
    padding: 15,
    marginVertical: 6,
    borderLeftWidth: 4,
    borderLeftColor: '#00E5FF',
  },
  taskItemDone: {
    borderLeftColor: '#00ff88',
  },
  checkbox: {
    width: 26,
    height: 26,
    borderWidth: 2,
    borderColor: '#00E5FF',
    borderRadius: 6,
    justifyContent: 'center',
    alignItems: 'center',
  },
  checkboxIcon: {
    color: '#00E5FF',
    fontSize: 16,
  },
  checkedIcon: {
    color: '#00ff88',
  },
  taskText: {
    flex: 1,
    marginLeft: 12,
    color: '#eee',
    fontSize: 16,
  },
  taskCompleted: {
    textDecorationLine: 'line-through',
    color: '#777',
  },
  deleteButton: {
    padding: 5,
  },
  deleteText: {
    color: '#FF1744',
    fontSize: 22,
    fontWeight: 'bold',
  },
  emptyText: {
    textAlign: 'center',
    color: '#555',
    fontSize: 16,
    marginTop: 40,
  },
});

export default App;
