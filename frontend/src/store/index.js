import create from 'zustand';

export const usePacienteStore = create((set) => ({
  paciente: null,
  pacientes: [],
  loading: false,
  error: null,

  setPaciente: (paciente) => set({ paciente }),
  setPacientes: (pacientes) => set({ pacientes }),
  setLoading: (loading) => set({ loading }),
  setError: (error) => set({ error }),
  clearError: () => set({ error: null }),
}));

export const useProntuarioStore = create((set) => ({
  prontuario: null,
  prontuarios: [],
  loading: false,
  error: null,

  setProntuario: (prontuario) => set({ prontuario }),
  setProntuarios: (prontuarios) => set({ prontuarios }),
  setLoading: (loading) => set({ loading }),
  setError: (error) => set({ error }),
  clearError: () => set({ error: null }),
}));

export const useAuthStore = create((set) => ({
  user: null,
  token: localStorage.getItem('token') || null,
  isAuthenticated: !!localStorage.getItem('token'),

  setUser: (user) => set({ user }),
  setToken: (token) => {
    if (token) {
      localStorage.setItem('token', token);
    } else {
      localStorage.removeItem('token');
    }
    set({ token, isAuthenticated: !!token });
  },
  logout: () => {
    localStorage.removeItem('token');
    set({ user: null, token: null, isAuthenticated: false });
  },
}));

export const useUIStore = create((set) => ({
  sidebarOpen: true,
  theme: localStorage.getItem('theme') || 'light',

  toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
  setTheme: (theme) => {
    localStorage.setItem('theme', theme);
    set({ theme });
  },
}));
