// Пример модульной архитектуры Vue, Pinia, TypeScript приложения по принципам Feature-Sliced Design (FSD)

// Структура проекта
src/
├── app/              // Глобальные конфигурации и начальная инициализация
│   ├── components/   // Глобальные компоненты (например, Layouts)
│   ├── providers/    // Глобальные провайдеры (например, Pinia, Router)
│   └── styles/       // Глобальные стили
│
├── entities/         // Основные сущности (Entities)
│   └── user/         // Сущность пользователя
│       ├── model/    // Логика состояния (Pinia store, API)
│       ├── ui/       // Компоненты UI (например, UserCard)
│       └── lib/      // Утилиты и хелперы
│
├── features/         // Фичи приложения (Features)
│   └── auth/         // Фича авторизации
│       ├── model/    // Состояние и бизнес-логика (Pinia store, API)
│       ├── ui/       // UI-компоненты (например, LoginForm)
│       └── lib/      // Утилиты и хелперы
│
├── pages/            // Страницы приложения (Pages)
│   ├── home/         // Главная страница
│   └── profile/      // Страница профиля
│       ├── index.vue // Входной файл страницы
│       └── model/    // Логика страницы (например, загрузка данных)
│
├── shared/           // Переиспользуемые модули (Shared)
│   ├── api/          // Конфигурации API
│   ├── ui/           // Переиспользуемые компоненты (например, Button)
│   └── lib/          // Общие утилиты и хелперы
│
└── widgets/          // Виджеты (Widgets)
    └── header/       // Виджет шапки
        ├── model/    // Логика состояния (например, текущее время)
        ├── ui/       // UI-компоненты (например, HeaderNav)
        └── lib/      // Утилиты и хелперы

// Пример Pinia store для фичи auth
// src/features/auth/model/authStore.ts
import { defineStore } from 'pinia';
import { ref } from 'vue';
import { loginApi } from '@/shared/api';

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null);
  const isLoading = ref(false);

  const login = async (credentials: { email: string; password: string }) => {
    isLoading.value = true;
    try {
      const response = await loginApi(credentials);
      user.value = response.data;
    } catch (error) {
      console.error('Login failed', error);
    } finally {
      isLoading.value = false;
    }
  };

  return { user, isLoading, login };
});

// Пример компонента LoginForm
// src/features/auth/ui/LoginForm.vue
<template>
  <form @submit.prevent="onSubmit">
    <input v-model="email" type="email" placeholder="Email" required />
    <input v-model="password" type="password" placeholder="Password" required />
    <button type="submit">Login</button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import { useAuthStore } from '../model/authStore';

export default defineComponent({
  setup() {
    const authStore = useAuthStore();
    const email = ref('');
    const password = ref('');

    const onSubmit = () => {
      authStore.login({ email: email.value, password: password.value });
    };

    return { email, password, onSubmit };
  }
});
</script>
